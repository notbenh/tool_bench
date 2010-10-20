package Tool::Bench::Item;
use Mouse;
use List::Util qw{min max sum};
use Time::HiRes qw{time};

# ABSTRACT: A single item to be benchmarked

=attr name

REQUIRED.

Stores the name of the item.

=cut

has name => 
   is => 'ro',
   isa => 'Str',
   required => 1,
;

=attr code

REQUIRED.

A CodeRef that is to be run.

=cut

has code => 
   is => 'ro',
   isa => 'CodeRef',
   required => 1,
;

has [qw{buildup teardown}] => 
   is => 'ro',
   isa => 'CodeRef',
   default => sub{sub{}},
;

=attr buildup

A CodeRef that is executed everytime before 'run' is called.

=attr teardown

A CodeRef that is executed everytime after 'run' is called.

=attr results

An ArrayRef that contains all the results.

=attr times

An ArrayRef that contains all the times that a specific run took.

=attr errors

An ArrayRef that contains all any errors that were captured.

=cut

has [qw{results times errors}]  =>
   is => 'rw',
   isa => 'ArrayRef',
   default => sub{[]},
;

=method run

  $item->run;    # a single run
  $item->run(3); # run the code 3 times

Execute code and capture results, errors, and the time for each run.

=cut

before run => sub{ shift->buildup->()  };
after  run => sub{ shift->teardown->() };

sub run {
   my $self = shift;
   my $loop = shift || 1;
   for (1..$loop) {
      local $@;
      my $result;
      my $start = time();
      eval { $result = $self->code->(); };
      my $stop = time();
      push @{ $self->times  }, $stop - $start;
      push @{ $self->results }, $result;
      push @{ $self->errors }, $@;
   }
   return $self->total_runs;
}


#---------------------------------------------------------------------------
#  REPORTING HOOKS
#---------------------------------------------------------------------------
=method total_time

The total time that all runs took to execute.

=method min_time

The fastest execute time.

=method max_time 

The slowest execute time.

=method avg_time

The averge execute time, total_time / total_runs.

= method total_runs

The number of runs that we've captured thus far.

=cut

sub total_time { sum @{shift->times} }
sub min_time   { min @{shift->times} }
sub max_time   { max @{shift->times} }

sub avg_time   { 
   my $self = shift;
   $self->total_time / $self->total_runs
}

sub total_runs { scalar(@{ shift->results }) }

1;
