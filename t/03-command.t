#!/usr/bin/perl 

use strict;
use warnings;

use Test::Most qw{no_plan};
#use Carp::Always;

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
BEGIN {

   use_ok('Tool::Bench::Command');
   can_ok('Tool::Bench::Command', qw{
      result
      setup 
      setup_validate
      run
      time_run
      run_validate
      cleanup
      cleanup_validate
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
eq_or_diff( $c->result->count, 1 , q{result} );
ok( $c->run_validate(sub{0}), q{plug in run_validate FAIL} );
ok( $c->run, q{run} );
eq_or_diff( $c->result->count, 1 , q{result unchanged, FAILED VALIDATE} );
ok( $c->run_validate(sub{1}), q{plug in run_validate PASS} );
ok( $c->run, q{run} );
eq_or_diff( $c->result->count, 2 , q{result update} );

#---------------------------------------------------------------------------
#  SIMPLE Workflow example:
#---------------------------------------------------------------------------
ok( $c = Tool::Bench::Command->new(
            setup => 'echo "hello" >> /tmp/testme',
            setup_validate => sub{-e '/tmp/testme'},
            cleanup => 'rm /tmp/testme',
            cleanup_validate => sub{!-e '/tmp/testme'},
            interpreter => 'cat',
            file => '/tmp/testme',
            run_validate => sub{$_=shift;m/hello/},
         ),
      q{workflow setup},
);

ok( $c->run(10), q{run} );
is( $c->result->count, 10, q{run count = result count} );
ok(!$c->time_run, q{run alone fails cleanup already run} );
is( $c->result->count, 10, q{run count = result count} );


#---------------------------------------------------------------------------
#  Check timeing
#---------------------------------------------------------------------------
ok( $c = Tool::Bench::Command->new(
            command => q{perl -e 'sleep 1'},
         ), q{setup}
);
is( $c->run(3), 3, q{sleep test});
eq_or_diff(
   [map{int}$c->result->times],
   [1,1,1],
   q{rough numbers look right},
);

