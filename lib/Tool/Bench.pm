package Tool::Bench;
use Mouse;
use List::Util qw{shuffle};
use Data::Dumper;

# ABSTRACT: simple bencher

has items => 
   is => 'rw',
   isa => 'ArrayRef[Tool::Bench::Item]',
   lazy => 1,
   default => sub{[]},
;

=method items_count

The number of stored items.

=cut

sub items_count { scalar( @{ shift->items } ) };

=method add_items

  $bench->add_items( $name => $coderef );
  $bench->add_items( $name => { startup  => $coderef,
                                code     => $coderef,
                                teardown => $coderef,
                                #varify  => $coderef, # currently not implimented
                              }
                   );
Startup and Teardown are untimed.

  Return items_count.
=cut

sub add_items {
   require Tool::Bench::Item;
   my $self  = shift;
   my %items = @_;
   for my $name ( keys %items ) {
      my $ref = ref($items{$name});
      my $new = $ref eq 'CODE' ? {code => $items{$name}}
              : $ref eq 'HASH' ? $items{$name}
              :                  {};

      push @{$self->items}, Tool::Bench::Item->new( name => $name, %$new );
   }
   return $self->items_count;
}

=method run

  $bench->run; # fire off the run method of all known items in shuffled order
  $bench->run(3); # run all items 3 times, random order non-sequential runs

=cut

sub run {
   my $self  = shift;
   my $times = shift || 1;
   my $count = 0;
   foreach my $i (1..$times) {
      foreach my $item ( shuffle( @{ $self->items } ) ) {
         $item->run;
         $count++;
      }
   }
   $count; # seems completely pointless but should return something at least margenly useful
}


#---------------------------------------------------------------------------
#  REPORTING
#---------------------------------------------------------------------------
sub report {
   my ($self, %args) = @_;
   my $type = $args{format} || 'Text';
   my $class = qq{Tool::Bench::Report::$type};
   eval qq{require $class} or die $@; #TODO this is messy
   $class->new->report(
    items  => $self->items,
    %args,
    );
}

no Mouse;
1;
