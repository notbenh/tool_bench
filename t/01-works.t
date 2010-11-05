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

      items
      items_count

      run
   });
      #report
}

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
ok my $tb  = Tool::Bench->new();
isa_ok  $tb, 'Tool::Bench';

my $before = 0;
my $after = 0;

ok $tb->add_items( ls  => sub{qx{ls}} ), q{add item pair};
ok $tb->add_items( die => { code     => sub{die},
                            buildup  => sub{$before++},
                            teardown => sub{$after++},
                          },
                 ), q{add item hash} ;
ok $tb->add_items( true => sub{1}, sleep => sub{sleep(1)}), q{add more then one item};
is $tb->items_count, 4, q{right count of items};


ok $tb->run,    q{run single};
ok $tb->run(3), q{run single};

is $tb->items->[0]->total_runs, 4, q{items were run 4 times each};
is $before, 4, q{startup ran the correct number of times};
is $after, 4,  q{teardown ran the correct number of times};

ok $tb->report, q{can get a report};
#eq_or_diff $tb->report('JSON'), {}, q{can get a report};
ok $tb->report('JSON'), q{can get a json report};
