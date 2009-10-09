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
   
      results
      add_result
      clear_results
      has_results
      run_count
      run_command

   });

}

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
ok( my $tb  = Tool::Bench->new() );
isa_ok(  $tb, 
   'Tool::Bench', 
   q{[Tool::Bench] new()},
);

ok( $tb->run_command('ls',10),
    q{was able to run tests},
);

ok( $tb->has_results );

