package Tool::Bench::Command;
use Moose;
use Capture::Tiny qw{capture};

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

has show_STDERR => (
   is => 'rw',
   isa => 'Bool',
   default => 0,
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

has [map{sprintf q{%s_validate},$_} EVENTS ] => (
   is => 'rw',
   isa => 'CodeRef',
   lazy_build => 1,
);
   
has [map{sprintf q{_build_%s_validate}, $_} EVENTS ] => (
   is => 'rw',
   isa => 'CodeRef',
   lazy => 1,
   default => sub{sub{1}},
);

=head2 cmd

=cut
sub cmd {
   my $self = shift;
   return ($self->has_command)                        ? $self->command
        : ($self->has_interpreter && $self->has_file) ? join ' ', $self->interpreter, $self->file
        :                                               undef ;
};

=head2 run

=cut
sub run {
   my $self = shift;
   my $num_of_runs = shift || 1;

   $self->run_setup;
   my $cmd = $self->cmd;

   foreach (1..$num_of_runs) {
      $self->time_run($cmd);
   }

   $self->run_cleanup;

   return $self->result->count;
}

=head2 run_setup

=cut

sub run_setup {
   my $self = shift;
   if (length($self->setup) > 0) {
      my $cmd = $self->setup;
      my $rv  = qx{$cmd};
      die '!!! SETUP FAILED TO VALIDATE' unless $self->setup_validate->($rv);
   }
}

=head2 run_cleanup

=cut

sub run_cleanup {
   my $self = shift;
   if (length($self->cleanup) > 0) {
      my $cmd = $self->cleanup;
      my $rv  = qx{$cmd};
      die '!!! CLEANUP FAILED TO VALIDATE' unless $self->cleanup_validate->($rv);
   }
}

=head2 time_run

=cut

sub time_run {
   my $self = shift;
   my $cmd  = shift || $self->cmd;
   my $note = shift;
   die '!!! NO COMMAND SPECIFIED' unless defined $cmd;

   $self->sw->unpause($note || $cmd);
   my ($stdout,$stderr) = capture {qx{$cmd}};
   $self->sw->pause;
   warn $stderr if $self->show_STDERR;

   $self->result->add(pop @{[map{$_->{elapsed_time}} @{$self->sw->as_unpaused_data->{laps}}]} )
      if $self->run_validate->($stdout);
}


1;


