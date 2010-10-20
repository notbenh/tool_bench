package Tool::Bench;
use Mouse;
require Tool::Bench::Result;
use Time::HiRes qw{time};

# ABSTRACT: simple bencher

has items => 
   is => 'rw',
   isa => 'ArrayRef[Tool::Bench::Item]',
   default => sub{[]},
;

=method run

  $bench->run( simple => { test    => 3,
                           expect  => 3,
                           note    => 'defaults to the $name if this key is not specified',
                         },
               system => { command => q{echo 'kitten'}, 
                           expect  => 'kitten',
                         },
               true   => { test    => sub{1} }, 
             )

=cut

sub run {
   my $self  = shift;
   my %items = @_;

   sub command { 
      my $cmd = shift;
      sub{my $_ = qx{$cmd}; chomp; $_};
   };

   for my $name ( keys %items ) {
      my $conf = { %{ $items{$name} }, name => $name };
      my $cmd = defined $conf->{command}     ? command($conf->{command})
              : ref($conf->{test}) eq 'CODE' ? $conf->{test}
              :                                sub{$conf->{test}} ;
      $conf->{start_time} = time;
      eval {
         $conf->{result}     = &$cmd;
      } or do {
         warn qq{ERROR: $@};
         $conf->{result} = 'ERROR';
         $conf->{error}  = $@;
      };
      $conf->{stop_time}  = time;

      push @{ $self->results }, 
           Tool::Bench::Result->new( %$conf );
   }
   scalar( @{ $self->results } );
}

sub report {
   my $self = shift;
   my $type = shift || 'Text';
   my $class = qq{Tool::Bench::Report::$type};
   eval qq{require $class} or die $@; #TODO this is messy
#die 'CLASS: ', $class;
   #Tool::Bench::Result::Text->new->report($self->results);
   $class->new->report($self->results);
}





no Mouse;
1;
