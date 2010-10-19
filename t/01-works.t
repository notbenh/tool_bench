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
      run
      results
   });
      #report
}

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
ok my $tb  = Tool::Bench->new(), 'new obj';
isa_ok(  $tb, 
   'Tool::Bench', 
   q{[Tool::Bench] new()},
);

for (1..3) {
   ok $tb->run( ls    => {command => 'ls'},
                sleep => {test    => sub{sleep(1);}},
                die   => {test    => sub{die 'dead'}},
              ), 
      qq{run $_};
}

eq_or_diff(
   $tb->results,
   {},
);

eq_or_diff(
   $tb->report,
   {},
);
