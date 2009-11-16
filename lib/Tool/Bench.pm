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

has count => (
   is => 'rw',
   isa => 'Int',
   default => 100,
);

sub cmd_loop {
   my $self   = shift;
   my $action = shift;
   return { map{
               my $c = $self->_commands->{$_};
               if ($c->can($action)) {
                  $_ => $c->$action;
                  #warn sprintf q{RUN: %s runing %s action.}, ref($c), $action ;
               }
               else {
                  warn sprintf q{!!!FAIL: %s does not have a %s action.}, ref($c), $action ;
               }
            } keys %{$self->_commands}
         };
}

sub run {shift->run_all_commands_interleaved(@_)}
sub run_all_commands_interleaved {
   my $self = shift;

   $self->cmd_loop('run_setup');
   for my $i (1..$self->count) {
      $self->cmd_loop('time_run'); 
   } 
   $self->cmd_loop('run_cleanup');
}

sub results {
   my $self = shift;
   $self->cmd_loop('result');
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
