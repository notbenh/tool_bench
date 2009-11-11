package Tool::Bench;
use Moose;
use MooseX::AttributeHelpers;
use Scalar::Util qw{looks_like_number};                                                                                                                               
use List::Util qw{min max};
use Benchmark::Stopwatch::Pause;
use Tool::Bench::Command;

=head1 NAME

Tool::Bench - Stuff to make Benchmarking easy.

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';


=head1 SYNOPSIS

=cut

has _commands => (
   is => 'rw',
   isa => 'HashRef', 
   auto_deref => 1,
   default => sub{{}},
);

sub add_command {
   my $self = shift;
   my $c    = scalar(@_);
   die 'Nothing useful was passed to add_command' if $c == 0 ;
   my $args = (ref($_[0]) eq 'HASH' && $c == 1) ? $_[0]
            : (ref($_[0]) eq ''     && $c == 1) ? {command => $_[0]}
            : (ref($_[0]) eq ''     && $c >  1) ? {@_}
            :                                     undef
            ;

   if ( defined $args ) {
      # a single hunk of info that looks useful
      my $obj = Tool::Bench::Command->new(%$args);
      my $cmd = $obj->cmd;
      die qq{I already have a record of this command: $cmd} 
         if $self->_commands->{$cmd};
      $self->_commands->{$cmd} = $obj;
   }
   else {
      # ohh look a list, manage expectations
      map{ $self->add_command($_) } grep{defined} (ref($_[0]) eq 'ARRAY') ? @{$_[0]} : @_;
   }
   
   return scalar( keys %{$self->_commands} );
}




__PACKAGE__->meta->make_immutable();
no Moose;

1;
__END__




has results => (
   metaclass => 'Collection::Array',
   is        => 'ro',
   isa       => 'ArrayRef',
   lazy      => 1,
   default   => sub { [] },
   provides  => {
      push   => 'add_result',
   },
   clearer   => 'clear_results',
   predicate => 'has_results',
);

=head1 METHODS

=head2 results

Get an arrayref of all the results currently stored.

=head2 add_results

Add a result to the stack.

=head2 has_results

Have we stored any results yet?

=head2 clear_results

Remove all exisitng results.

=cut

has run_count => (
   is => 'rw',
   isa => 'Int',
   default => 100,
);

=head2 run_command

Takes a string to run as a comand to run, an integer for how many times to run said command.

Results are stored in results.

=cut

sub run_command {
   my ($self,$cmd,$count) = @_;
   my $sw = Benchmark::Stopwatch::Pause->new->start->pause;
   for (1..($count||$self->run_count)) {
      $sw->unpause($_);
      my $rv = qx($cmd); #better trap output for use if needed
      $sw->pause;
      # if you want to check the results.... do it here.
   }
   $sw->stop;

   my $data = $sw->as_unpaused_data;
   shift @{$data->{laps}}; # no point in keeping _start_
   my @times = map{$_->{elapsed_time}} @{$data->{laps}};
   $self->add_result(
          { max   => max(@times),
            min   => min(@times),
            times => \@times,
            total => $data->{total_elapsed_time},
            avg   => (scalar(@times)) ? $data->{total_elapsed_time}/scalar(@times)
                                      : 0,
            cmd   => $cmd,
          }
   );
}


=head1 AUTHOR

ben hengst, C<< <notbenh at cpan.org> >>

=head1 BUGS

Please post bugs to github L<http://github.com/notbenh/tool_bench/issues>.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Tool::Bench

You can also look for information at:

=over 4

=item * Project hosted at

L<http://github.com/notbenh/tool_bench>

=back


=head1 ACKNOWLEDGEMENTS

Thanks goes to Eric Wilhelm and Jonathan Leto, and the entire euler_bench team for making this possible.

=head1 COPYRIGHT & LICENSE

Copyright 2009

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

__PACKAGE__->meta->make_immutable();
no Moose;

1;
