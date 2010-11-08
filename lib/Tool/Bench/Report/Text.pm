package Tool::Bench::Report::Text;
use Mouse;
use List::Util qw{min max sum };


=head1 Text Report

   min   max  total  avg  count name
  0.000 0.000 0.000 0.000     4 true
  0.000 0.000 0.000 0.000     4 die
  0.002 0.002 0.009 0.002     4 ls [some note]
  1.000 1.000 4.000 1.000     4 sleep

=cut

sub report {
   my ($self,%args) = @_;

   sprintf qq{%s\n\n},
           join qq{\n},
               q{ min   max  total  avg   count name},
               map{ sprintf q{%0.3f %0.3f %0.3f %0.3f % 5d %s %s},
                            $_->min_time,
                            $_->max_time,
                            $_->total_time,
                            $_->avg_time,
                            $_->total_runs,
                            $_->name,
                            #length($_->note) ? sprintf q{[NOTE: %s]}, $_->note : ''
                            length($_->note) ? sprintf q{[%s]}, $_->note : ''
                  } sort {$a->total_time <=> $b->total_time} @{$args{items}};
   
};

1;

