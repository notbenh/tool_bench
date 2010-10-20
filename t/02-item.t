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
__END__
#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
ok my $i  = Tool::Bench::Item->new(name => 'ls', code => sub{qx{ls}});
isa_ok $i, 'Tool::Bench::Item';





