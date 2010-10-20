package Tool::Bench;
use Mouse;
require Tool::Bench::Result;
use List::Util qw{shuffle};

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
  $bench->add_items( $name => { before => $coderef,
                                code   => $coderef,
                                after  => $coderef,
                                #varify => $coderef, # currently not implimented
                              }
                   );

Before and after events are untimed.

  Return items_count.
=cut

sub add_items {
   require Tool::Bench::Item;
   my $self  = shift;
   my %items = @_;
   for my $name ( keys %items ) {
      my $ref = ref($items{$name});
      my $code = $ref eq 'CODE' ? $items{$name}
               : $ref eq 'HASH' ? $items{$name}->{code}
               :                  undef;
      my $item = Tool::Bench::Item->new( name => $name, code => $code );
      if( $ref eq 'HASH' ) {
         $item->meta->add_before_method_modifier('run', $items{$name}->{before})
            if exists $items{$name}->{before} && ref($items{$name}->{before}) eq 'CODE';
         $item->meta->add_after_method_modifier('run', $items{$name}->{after})
            if exists $items{$name}->{after} && ref($items{$name}->{after}) eq 'CODE';
      }

      push @{$self->items}, $item;
   }
   return $self->items_count;
}

sub run {
   my $self  = shift;
   my $times = shift || 1;
   foreach my $i (1..$times) {
      foreach my $item ( shuffle( @{ $self->items } ) ) {
         $item->run;
      }
   }
}


#---------------------------------------------------------------------------
#  REPORTING
#---------------------------------------------------------------------------
sub report {
   my $self = shift;
   my $type = shift || 'Text';
   my $class = qq{Tool::Bench::Report::$type};
   eval qq{require $class} or die $@; #TODO this is messy
   #Tool::Bench::Result::Text->new->report($self->results);
   $class->new->report($self->items);
}

no Mouse;
1;
