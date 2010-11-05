package Tool::Bench::Report::JSON;
use Mouse;
use JSON;
use List::Util qw{min max sum };


=head1 JSON Report

   [
      {
         'max_time' => '3.50475311279297e-05',
         'total_runs' => 4,
         'min_time' => '2.09808349609375e-05',
         'avg_time' => '2.55107879638672e-05',
         'name' => 'true',
         'total_time' => '0.000102043151855469',
         'times' => [
                      '2.40802764892578e-05',
                      '2.09808349609375e-05',
                      '3.50475311279297e-05',
                      '2.19345092773438e-05'
                    ]
       },
   ]

=cut

sub report {
   my $self  = shift;
   my $items = shift;
   
   encode_json( [ map{ my $item = $_;
                       my $x =
                       { map{ $_ => $item->$_ } qw{ min_time   max_time
                                                    total_time avg_time
                                                    total_runs name
                                                    times
                                                  }
                       }
                     } sort {$a->total_time <=> $b->total_time} @$items
                ]);
};

1;

