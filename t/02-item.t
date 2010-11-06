#!/usr/bin/perl 

use strict;
use warnings;

use Test::Most qw{no_plan};
use Data::Dumper;
#use Carp::Always;

BEGIN {

   require_ok('Tool::Bench::Item');

   can_ok('Tool::Bench::Item', qw{
      new 

      name
      code
      results
      times
      errors

      run

      total_time
      min_time
      max_time
      avg_time

      total_runs
   });


};

my $items = {
                ls  => sub{qx{ls}},
                die => sub{die},
            };

for my $name ( keys %$items ) {

   ok my $i  = Tool::Bench::Item->new(name => $name, code => $items->{$name} ), qq{[$name] build item};
   ok $i->run, qq{[$name] running};
   ok $i->run(3), qq{[$name] running with built in looping};
   is $i->total_runs, 4, q{run count is correct};
   cmp_ok( @{$i->times}, '==', 4, 'got the right number of times' );

   map { cmp_ok( $_, '>=', 0, 'all times are positive') } @{$i->times};

   # should we have 4 empty error strings, or no errors?
   cmp_ok( @{$i->errors}, '==', 4, 'got the right number of errors' );

   cmp_ok( @{$i->results}, '==', 4, 'got the right number of results' );
}
