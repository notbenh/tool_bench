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

      add
      run
      summary
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
is $tb->{instance_class}, 'Tool::Bench::Instance', 'right class for instance';
isa_ok $tb->{instance}, $tb->{instance_class};
is_deeply $tb->{commands}, [], 'commands check out';

