package Tool::Bench::Report::Text;
use Mouse;
use List::Util qw{min max sum };

sub report {
   my $self    = shift;
   my $results = shift;

use Util::Log;
   join qq{\n},
      q{ min   max  total  avg  count name},
      map{ sprintf q{%0.3f %0.3f %0.3f %0.3f % 5d %s},
                   $_->min_time,
                   $_->max_time,
                   $_->total_time,
                   $_->avg_time,
                   $_->total_runs,
                   $_->name,
         } sort {$a->total_time <=> $b->total_time} @$results
};

1;

