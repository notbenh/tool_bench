package Tool::Bench::Result;
use Mouse;

has name => 
   is => 'ro',
   isa => 'Str',
   required => 1,
;

has result => 
   is => 'ro',
   isa => 'Maybe[Value]',
   required => 1,
;

has [qw{expected error note}] =>
   is => 'ro',
   isa => 'Maybe[Value]',
;

has [qw{start_time stop_time}] => 
   is => 'ro',
   isa => 'Num',
   required => 1,
;
has total_time => 
   is => 'ro', 
   isa => 'Num',
   lazy => 1,
   default => sub{
      my $self = shift;
      $self->stop_time - $self->start_time;
   },
;
   
   
no Mouse;
1;
