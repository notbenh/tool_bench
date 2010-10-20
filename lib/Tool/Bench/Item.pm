package Tool::Bench::Item;
use Mouse;
use List::Util qw{min max sum};
use Time::HiRes qw{time};

has name => 
   is => 'ro',
   isa => 'Str',
   required => 1,
;

has code => 
   is => 'ro',
   isa => 'CodeRef',
   required => 1,
;

has [qw{results times errors}]  =>
   is => 'rw',
   isa => 'ArrayRef',
   default => sub{[]},
;


sub run {}


#---------------------------------------------------------------------------
#  REPORTING HOOKS
#---------------------------------------------------------------------------
sub total_time { sum( shift->times ) }
sub min_time   { min( shift->times ) }
sub max_time   { max( shift->times ) }
sub avg_time   { 
   my $self = shift;
   $self->total_time / $self->total_runs
}

sub total_runs { scalar(@{ shift->results }) }

1;
