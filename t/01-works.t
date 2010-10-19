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
      run
      results
   });
      #report
}

#-----------------------------------------------------------------
#  
#-----------------------------------------------------------------
ok my $tb  = Tool::Bench->new(), 'new obj';
isa_ok(  $tb, 
   'Tool::Bench', 
   q{[Tool::Bench] new()},
);

for (1..3) {
   ok $tb->run( ls    => {command => 'ls'},
                sleep => {test    => sub{sleep(1);}},
                die   => {test    => sub{die 'dead'}},
              ), 
      qq{run $_};
}

is scalar(@{ $tb->results}), 9, q{right number of results};

ok $tb->report, q{can report};

__END__
eq_or_diff(
   $tb->results,
   {},
);

eq_or_diff(
   $tb->report,
   {},
);

__END__
#   Failed test at t/01-works.t line 40.
# +----+---------------------------------------------+----+----------+
# | Elt|Got                                          | Elt|Expected  |
# +----+---------------------------------------------+----+----------+
# *   0|[                                            *   0|{}        *
# *   1|  bless( {                                   *    |          |
# *   2|    name => 'ls',                            *    |          |
# *   3|    result => 'dist.ini                      *    |          |
# *   4|lib                                          *    |          |
# *   5|t',                                          *    |          |
# *   6|    start_time => '1287529249.30534',        *    |          |
# *   7|    stop_time => '1287529249.30731'          *    |          |
# *   8|  }, 'Tool::Bench::Result' ),                *    |          |
# *   9|  bless( {                                   *    |          |
# *  10|    error => 'dead at t/01-works.t line 34.  *    |          |
# *  11|',                                           *    |          |
# *  12|    name => 'die',                           *    |          |
# *  13|    result => 'ERROR',                       *    |          |
# *  14|    start_time => '1287529249.3075',         *    |          |
# *  15|    stop_time => '1287529249.30753'          *    |          |
# *  16|  }, 'Tool::Bench::Result' ),                *    |          |
# *  17|  bless( {                                   *    |          |
# *  18|    name => 'sleep',                         *    |          |
# *  19|    result => 1,                             *    |          |
# *  20|    start_time => '1287529249.30755',        *    |          |
# *  21|    stop_time => '1287529250.30764'          *    |          |
# *  22|  }, 'Tool::Bench::Result' ),                *    |          |
# *  23|  bless( {                                   *    |          |
# *  24|    name => 'ls',                            *    |          |
# *  25|    result => 'dist.ini                      *    |          |
# *  26|lib                                          *    |          |
# *  27|t',                                          *    |          |
# *  28|    start_time => '1287529250.3082',         *    |          |
# *  29|    stop_time => '1287529250.31031'          *    |          |
# *  30|  }, 'Tool::Bench::Result' ),                *    |          |
# *  31|  bless( {                                   *    |          |
# *  32|    error => 'dead at t/01-works.t line 34.  *    |          |
# *  33|',                                           *    |          |
# *  34|    name => 'die',                           *    |          |
# *  35|    result => 'ERROR',                       *    |          |
# *  36|    start_time => '1287529250.31037',        *    |          |
# *  37|    stop_time => '1287529250.3104'           *    |          |
# *  38|  }, 'Tool::Bench::Result' ),                *    |          |
# *  39|  bless( {                                   *    |          |
# *  40|    name => 'sleep',                         *    |          |
# *  41|    result => 1,                             *    |          |
# *  42|    start_time => '1287529250.31043',        *    |          |
# *  43|    stop_time => '1287529251.31049'          *    |          |
# *  44|  }, 'Tool::Bench::Result' ),                *    |          |
# *  45|  bless( {                                   *    |          |
# *  46|    name => 'ls',                            *    |          |
# *  47|    result => 'dist.ini                      *    |          |
# *  48|lib                                          *    |          |
# *  49|t',                                          *    |          |
# *  50|    start_time => '1287529251.31099',        *    |          |
# *  51|    stop_time => '1287529251.31314'          *    |          |
# *  52|  }, 'Tool::Bench::Result' ),                *    |          |
# *  53|  bless( {                                   *    |          |
# *  54|    error => 'dead at t/01-works.t line 34.  *    |          |
# *  55|',                                           *    |          |
# *  56|    name => 'die',                           *    |          |
# *  57|    result => 'ERROR',                       *    |          |
# *  58|    start_time => '1287529251.3132',         *    |          |
# *  59|    stop_time => '1287529251.31323'          *    |          |
# *  60|  }, 'Tool::Bench::Result' ),                *    |          |
# *  61|  bless( {                                   *    |          |
# *  62|    name => 'sleep',                         *    |          |
# *  63|    result => 1,                             *    |          |
# *  64|    start_time => '1287529251.31325',        *    |          |
# *  65|    stop_time => '1287529252.31333'          *    |          |
# *  66|  }, 'Tool::Bench::Result' )                 *    |          |
# *  67|]                                            *    |          |
# +----+---------------------------------------------+----+----------+
not ok 9
#   Failed test at t/01-works.t line 44.
# +----+--------------------------------------+----+----------+
# | Elt|Got                                   | Elt|Expected  |
# +----+--------------------------------------+----+----------+
# *   0| min   max  total  avg  count name\n  *   0|          *
# *   1|0.002 0.002 0.006 0.002     3 ls\n    *   1|          *
# *   2|0.000 0.000 0.000 0.000     3 die     *    |          |
# *   3|1.000 1.000 3.000 1.000     3 sleep   *    |          |
# +----+--------------------------------------+----+----------+

