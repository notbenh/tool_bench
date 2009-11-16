#!/usr/bin/perl 

use strict;
use warnings;

BEGIN {
   package Tool::Bench::Runner;
   use Moose;
   use Data::Dumper; sub D (@) {print Dumper(@_)};
   use JSON;
   with 'MooseX::Getopt';

   has controler => (
      is => 'rw', 
      isa => 'Tool::Bench', 
      lazy => 1,
      default => sub{
         require Tool::Bench; 
         Tool::Bench->new(count => shift->count)
      },
      handles => [qw{add_command run results}],
   );

   has count   => ( is => 'rw', isa => 'Int', default => 100);
   has command => ( is => 'rw', isa => 'ArrayRef', auto_deref=>1, default => sub{[]});
   has type    => ( is => 'rw', isa => 'Str', default => 'report');

   # you do not have access to self at the type check state
   sub BUILD {
      my $self   = shift;
      my $method = sprintf q{type_%s}, $self->type;

      die sprintf q{!!! FAIL %s is not a valid type because %s is not a valid method}, $self->type, $method
         unless $self->can($method);
   }


   sub report {
      my $self = shift;
      my $type = 'type_'. $self->type;
      my $res  = $self->results;
      return 'No data found' unless scalar(@$res);
      $self->$type( $res );
   }

   sub type_report {
      my ($self,$data) = @_;
      my $length_longest_cmd = [sort {$b<=>$a} map{length} map{$_->{cmd}} @$data ]->[0];
      my $fmt_cmd = sprintf qq{%%-%ds}, $length_longest_cmd ;
      join qq{\n},
         sprintf( qq{$fmt_cmd  count   min    max   total average}, ''),
         map { my $row = $_;
               sprintf qq{$fmt_cmd %5d  %02.4f %02.4f %02.4f %02.4f} , map{$row->{$_}} qw{cmd count min max total average}
             } sort {$a->{average} <=> $b->{average}} @$data;
   }

   sub type_data {
      my ($self,$data) = @_;
      Dumper( $data );
   }

   sub type_json {
      my ($self,$data) = @_;
      to_json( $data );
   }
};

my $runner = Tool::Bench::Runner->new_with_options();

map{ $runner->add_command($_) } $runner->command;
$runner->run;
print $runner->report, qq{\n};
