#!/usr/bin/perl 
use strict;
use warnings;

=head1 WHAT?

This is just a copy of the Moose based Tool::Bench::Runner, rewritten with Mouse as a dep. 

=head1 EXAMPLE

  PERL5LIB=lib script/bench.pl --interp 'perl -Ilib' --file 't/01-works.t' --count 3 --format JSON

=head1 TODO

needs docs

=cut

BEGIN {
   package Tool::Bench::Runner;
   use Mouse;
   use Mouse::Util::TypeConstraints;
   require Tool::Bench;
   with qw{MouseX::Getopt};

   has [qw{file interp}] => 
      is => 'rw',
      isa => 'Str',
      required => 1,
   ;

   has count => 
      is => 'rw',
      isa => 'Int',
      default => 1,
   ;

   enum 'ReportType' => qw(Text JSON); # TODO: this should be automated? or just let it fail if theres a non-valid type?

   has format => 
      is => 'rw',
      isa => 'ReportType',
      default => 'text',
   ;

   sub run {
      my $self = shift;
      my $bench= Tool::Bench->new;
      my $cmd = join ' ', $self->interp, $self->file;
      $bench->add_items( $self->file => sub{qx{$cmd}});
      $bench->run($self->count);
      print $bench->report($self->format);
      return 0;
   }
};

Tool::Bench::Runner->new_with_options->run();


