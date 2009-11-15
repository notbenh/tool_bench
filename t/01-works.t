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
      add_command

   });

=pod
      results
      clear_results
      has_results
      run_count
      run_command
=cut
}

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
ok( my $tb  = Tool::Bench->new() );
isa_ok(  $tb, 
   'Tool::Bench', 
   q{[Tool::Bench] new()},
);

ok( $tb->add_command('date'), q{date} );
eq_or_diff( [keys %{$tb->_commands}], [qw{date}], q{stored?});
isa_ok( $tb->_commands->{date}, 'Tool::Bench::Command' );

ok( $tb->add_command(interpreter=>'ls', file => '/tmp'), q{ls /tmp});
ok( $tb->add_command({command=>'hostname'},{command=>'perl -V'}), q{twofer});
dies_ok {$tb->add_command()} q{blank} ;

eq_or_diff(
   [keys %{$tb->_commands}],
   ['perl -V', 'date', 'hostname', 'ls /tmp'],
   q{command check},
);

ok( $tb->run_count(10), q{sane} );
ok( $tb->run, q{things ran},);
eq_or_diff(
   [map{ref($_)} values %{$tb->results_objects}],
   [map{'Tool::Bench::Result'}1..4],
   q{ok so the results look sane}
);

eq_or_diff(
   $tb->results,
   {},
);
