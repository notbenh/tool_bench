package Tool::Bench::Report::Text;
use Mouse;
use List::Util qw{min max sum };

sub report {
   my $self    = shift;
   my $results = shift;
   my $out     = {};
   foreach my $result (@$results) {
      push @{$out->{$result->name}}, $result->total_time;
   }

   join qq{\n},
      q{ min   max  total  avg  count name},
      map{ my @times = @{$out->{$_}};
           sprintf q{%0.3f %0.3f %0.3f %0.3f % 5d %s},
                   min( @times ),
                   max( @times ),
                   sum( @times ),
                   sum( @times )/scalar(@times),
                   scalar(@times),
                   $_,
         } keys %$out;
};

1;

