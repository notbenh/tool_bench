package Tool::Bench::Result;
use Moose;
use MooseX::AttributeHelpers;
use POSIX qw{floor};
use List::Util;

has times => (
   metaclass => 'Collection::Array',
   is        => 'ro',
   isa       => 'ArrayRef[Num]',
   auto_deref => 1,
   default   => sub { [] },
   provides  => {
      unshift=> 'unshift',
      pop    => 'pop',
      shift  => 'shift',
      sort_in_place => 'sort_times_in_place',
   },
   clearer   => 'clear_times',
   predicate => 'has_times',
);


sub add {
   my $self = shift;
   #put them in reverse order so that they maintain given order
   map{$self->unshift($_)} reverse @_; 
}

=head1 METHODS

=head2 times

Get an arrayref of all the times currently stored.

=head2 has_times

=head2 clear_times

=head2 add

Add time to the top of the times stack, can take an array of entries.

=head2 unshift

=head2 pop

=head2 shift

=head2 min

=head2 max

=head2 sum

=head2 total

=head2 mean

=head2 average

=head2 median

=head2 sort

=head2 reverse

=head2 count

=cut

sub min {
   my $self = shift;
   List::Util::min $self->times ;
}
sub max {
   my $self = shift;
   List::Util::max $self->times ;
}
sub total {shift->sum};
sub sum {
   my $self = shift;
   List::Util::sum $self->times;
}
sub mean {shift->average};
sub average {
   my $self = shift;
   ($self->count) ? ($self->sum / $self->count) : 0;
}
sub median {
   my $self = shift;
   #$self->sort modifies the list thus were going to pull a copy
   my @sorted = sort {$a<=>$b} $self->times; 
   ($self->count %2) ? (List::Util::sum splice(@sorted, floor($self->count/2) - 1, 2) ) / 2 
                     : splice(@sorted, floor($self->count/2) - 1, 1)
                     ;
}
# don't know how useful this would be?
#sub mode {
#}

sub count {
   my $self = shift;
   scalar(@{ $self->times });
}
sub sort {
   my $self = shift;
   my $sorter = (defined $_[0] && ref($_[0]) eq 'CODE') ? $_[0] : sub{$_[0]<=>$_[1]};
   $self->sort_times_in_place($sorter);
   return $self->count;
}
sub reverse {
   my $self = shift;
   $self->sort(sub{$_[1]<=>$_[0]});
};


1;


