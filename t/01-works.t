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

ok $tb->add_items( ls  => sub{qx{ls}} ), q{add item pair};
ok $tb->add_items( die => { code   => sub{die},
                            before => sub{warn 'BEFORE'},
                            after  => sub{warn 'AFTER'},
                          },
                 ), q{add item hash} ;
ok $tb->add_items( true => sub{1}, false => sub{0}), q{add more then one item};
is $tb->items_count, 4, q{right count of items};


ok $tb->run,    q{run single};
ok $tb->run(3), q{run single};

is $tb->items->[0]->total_runs, 4, q{items were run 4 times each};

