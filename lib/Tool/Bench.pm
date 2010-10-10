package Tool::Bench;
use strict;
use warnings;

# ABSTRACT: easy benching

sub new { bless {}, shift };

=method add

  $bench->add( name => { test   => sub{ $_ = qx{echo 'kitten'}; chomp; $_ }, 
                         expect => 'kitten',
                         type   => 'equal',
                       },
             )

=cut

sub add {
   my $self = shift;
   my $name = shift;
   $name = 'test_'.$name unless $name =~ m/^test_/;

   if ( $self->can($name) ) {
      warn qq{there is already a test named $name, skipping.};
      return;
   }

   my ($cmd, $value, $note) = @{$_[0]};
   { no strict;
     *{join '::', __PACKAGE__, $name} = sub{ my $_ = qx{$cmd}; chomp; assert_equal($_, $value, $note) };
   };
}

   sub build {
      my %cmd = @_;
      foreach my $test (keys %cmd) {
         add_cmd($test, $cmd{$test});
      }
   }






__END__

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

sub results_objects {
   my $self = shift;
   $self->cmd_loop('result');
}

sub results {
   my $self = shift;
   [ map{ my $cmd = $_;
          { cmd => $cmd,
            map{ $_ => [$self->_commands->{$cmd}->result->$_] } qw{min max average times total count}
          }
        } keys %{$self->results_objects}
   ];
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
