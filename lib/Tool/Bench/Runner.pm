package Tool::Bench::Runner;
use Moose;
use Moose::Util::TypeConstraints;
require Tool::Bench;

=head1 WHAT IS THIS

   A quickie runner CLI for bench, requires a bunch of moose stuff for getting things off the ground.

=cut

with qw{MooseX::Runnable 
        MooseX::Getopt
       };

has [qw{file interp}] => 
   is => 'rw',
   isa => 'Str',
   required => 1,
;

has count => 
   is => 'rw',
   isa => 'Int',
   default => 1,
;

enum 'ReportType' => qw(Text JSON);

has format => 
   is => 'rw',
   isa => 'ReportType',
   default => 'text',
;

=head1 EXAMPLE

  PERL5LIB=lib mx-run Tool::Bench::Runner --interp 'perl -Ilib' --file 't/01-works.t' --count 3 --format JSON

=cut

sub run {
   my $self = shift;
   my $bench= Tool::Bench->new;
   my $cmd = join ' ', $self->interp, $self->file;
   $bench->add_items( $self->file => sub{qx{$cmd}});
   $bench->run($self->count);
   print $bench->report($self->format);
   return 0;
}

1;


