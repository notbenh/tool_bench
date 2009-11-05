#!/usr/bin/perl 

use strict;
use warnings;

use Test::Most qw{no_plan};

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
BEGIN {

   use_ok('Tool::Bench::Result');
   can_ok('Tool::Bench::Result', qw{
      times
      has_times
      clear_times
      add
      pop
      shift
      unshift
      min
      max
      sum
      average
      count
      sort
      reverse
   });

}

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
ok( my $r  = Tool::Bench::Result->new() );
isa_ok(  $r, 
   'Tool::Bench::Result', 
   q{[Tool::Bench::Result] new()},
);

my @times = reverse 1..10; # new list op does not dec
ok( $r->add(@times), q{seed} );
eq_or_diff( [$r->times], \@times, q{sane} );
is($r->min, 1, q{min} );
is($r->max, 10, q{max} );
is($r->pop, 1, q{pop});
is($r->shift, 10, q{shift});
eq_or_diff( [$r->times], [reverse 2..9], q{sane} );
ok( $r->add(1,10), q{add again} );
eq_or_diff( [$r->times], [1,10,reverse 2..9], q{sane} );
ok( $r->sort, q{sort} );
eq_or_diff( [$r->times], [1..10], q{sane} );
ok( $r->reverse, q{reverse} );
eq_or_diff( [$r->times], [reverse 1..10], q{sane} );
ok( $r->add(11), q{it goes to 11} );
is( $r->count, 11, q{count} );
is( $r->sum, 66, q{sum} );
is( $r->average, 6, q{average} );
is( $r->mean, 6, q{mean} );
is( $r->median, 5.5, q{median} );
is( $r->shift, 11 ,q{back to 10});
is( $r->count, 10, q{count} );
is( $r->sum, 55, q{sum} );
is( $r->mean, 5.5, q{mean} );
is( $r->median, 5, q{median} );


ok( $r->has_times, q{has} );
ok( $r->clear_times, q{clear} );
ok(!$r->has_times, q{has not} );


