#!/usr/bin/perl 
use strict;
use warnings;
use Test::Mini::Runner;

{
   package My;
   use base 'Test::Mini::TestCase';
   use Test::Mini::Assertions;
   #use Data::Dumper; sub DUMP (@){warn Dumper(@_)};

   sub add_cmd {
      my $name = shift;
      $name = 'test_'.$name unless $name =~ m/^test_/;
      my ($cmd, $value, $note) = @{$_[0]}; 
      { no strict;
        *{join '::', __PACKAGE__, $name} = sub{ my $_ = qx{$cmd}; chomp; assert_equal($_, $value, $note) };
      };
   }
   
   sub build {
      my %cmd = @_;
      foreach my $test (keys %cmd) {
         add_cmd($test, $cmd{$test});
      }
   }
   

   #sub test_one { assert_equal(1,'1', 'works')}
   
}

My::build(
   one => [ q{echo 'kitten'} => kitten => 'kitten test' ],
   #two => [ q{
);

END { warn 'all done' };
