#!/usr/bin/perl 

use strict;
use warnings;

use Test::Most qw{no_plan};
use Carp::Always;

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
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

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
my $items = { ls  => sub{qx{ls}},
              die => sub{die},
            };

for my $name ( keys %$items ) {

   ok my $i  = Tool::Bench::Item->new(name => $name, code => $items->{$name} ), qq{[$name] build item};
   ok $i->run, qq{[$name] running};
   ok $i->run(3), qq{[$name] running with built in looping};
   is $i->total_runs, 4, q{run count is correct};

   #for (qw{results times errors}) {
   #   eq_or_diff( $i->$_, {}, qq{[$name] $_} );
   #}

}




