package Tool::Bench::Command;
use Moose;

=head1 Methods

=head2 sw

=head2 result

=cut

has sw => (
   is => 'rw',
   isa => 'Benchmark::Stopwatch::Pause',
   default => sub{
      use Benchmark::Stopwatch::Pause;
      Benchmark::Stopwatch::Pause->new->start->pause;
   },
);

has result => (
   is => 'rw',
   isa => 'Tool::Bench::Result',
   lazy => 1,
   default => sub{
      require Tool::Bench::Result;
      Tool::Bench::Result->new;
   },
);

use constant DATA   => qw{setup interpreter file command cleanup};
use constant EVENTS => qw{setup run cleanup};

=head2 setup

=head2 _build_setup

=head2 interpreter

=head2 _build_interpreter

=head2 file

=head2 _build_file

=head2 command

=head2 _build_command

=head2 cleanup

=head2 _build_cleanup

=cut

has [DATA] => ( 
   is => 'rw',
   isa => 'Str',
   lazy_build => 1,
);
has [map{sprintf q{_build_%s}, $_} DATA ] => (
   is => 'rw',
   isa => 'Str',
   lazy => 1,
   default => '',
);

has [map{sprintf q{%s_validate'},$_} EVENTS ] => (
   is => 'rw',
   isa => 'CodeRef',
   lazy_build => 1,
);
   
has [map{sprintf q{_build_%s_validate}, $_} EVENTS ] => (
   is => 'rw',
   isa => 'CodeRef',
   lazy => 1,
   default => sub{1},
);

=head2 run

=cut

sub run {
   my $self = shift;
   my $num_of_runs = shift || 1;

   if (length($self->setup) > 0) {
      my $rv = qx{$self->setup};
      die '!!! SETUP FAILED TO VALIDATE' unless $self->setup_validate->($rv);
   }

   my $cmd = ($self->has_command)                        ? $self->command
           : ($self->has_interpreter && $self->has_file) ? join ' ', $self->interpreter, $self->file
           :                                               undef ;

   foreach (1..$num_of_runs) {
      $self->time_run($cmd);
   }

   if (length($self->cleanup) > 0) {
      my $rv = qx{$self->setup};
      die '!!! CLEANUP FAILED TO VALIDATE' unless $self->cleanup_validate->($rv);
   }
   return $self->result->count;
}

=head2 time_run

=cut

sub time_run {
   my $self = shift;
   my $cmd  = shift;
   die '!!! NO COMMAND SPECIFIED' unless defined $cmd;

   $self->sw->unpause($cmd);
   my $rv = qx{$cmd};
   $self->sw->pause;
use Data::Dumper;
print Dumper($self->sw->as_unpaused_data);
   $self->result->add(pop @{[map{$_->{elapsed_time}} @{$self->sw->as_unpaused_data->{laps}}]} );
}


1;


