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

ok( $tb->add_commnad(interpreter=>'ls', file => '/tmp'), q{ls /tmp});
ok( $tb->add_command({command=>'hostname'},{command=>'perl -V'}), q{twofer});
dies_ok {$tb->add_command()}, q{blank} ;
dies_ok {$tb->add_command([{},{}])}, q{many blanks} ;





__END__
ok( $tb->run_command('ls',10),
    q{was able to run tests},
);

ok( $tb->has_results );

