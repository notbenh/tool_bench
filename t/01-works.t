#!/usr/bin/perl 

use strict;
use warnings;

use Test::Most qw{no_plan};

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
BEGIN {

   use_ok('Tool::Bench');
   can_ok('Tool::Bench', qw{
      new
      instance
      tests
      runner

      add
      run
      results
      report
   });
}

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
ok my $tb  = Tool::Bench->new(), 'new obj';
isa_ok(  $tb, 
   'Tool::Bench', 
   q{[Tool::Bench] new()},
);
isa_ok $tb->instance, 'Tool::Bench::Instance';

cmp_bag( 
   $tb->add( ls    => {command => 'ls .'},
             prove => {command => 'prove'},
           ),
   [qw{ls prove}],
);

eq_or_diff(
   $tb->run(),
   {},
);

eq_or_diff(
   $tb->results(),
   {},
);
