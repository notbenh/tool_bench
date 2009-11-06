#!/usr/bin/perl 

use strict;
use warnings;

use Test::Most qw{no_plan};

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
BEGIN {

   use_ok('Tool::Bench::Command');
   can_ok('Tool::Bench::Command', qw{
      result
      run
      setup 
      run 
      cleanup
   });

}

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
ok( my $c  = Tool::Bench::Command->new() );
isa_ok(  $c, 
   'Tool::Bench::Command', 
   q{[Tool::Bench::Command] new()},
);

ok( $c->interpreter('ls'), q{interp} );
ok( $c->file('.'), q{file} );

eq_or_diff( $c->result->count, 0 , q{result empty} );
ok( $c->run, q{run} );

