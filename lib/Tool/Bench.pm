package Tool::Bench;
use strict;
use warnings;

# ABSTRACT: easy benching
BEGIN {
   $ENV{TEST_MINI_NO_AUTORUN} => 1; # disable some of Test::Mini's auto-magic
};

sub new { my $instance = join '::', __PACKAGE__ , 'Instance';
          my $self = { instance => bless( {}, $instance),
                       instance_class => $instance,
                       commands => [],
                     };
          return bless $self, shift;
        };

=method add

  $bench->add( simple  => { test   => 3,
                            expect => 3,
                          },
               complex => { test => sub{ $_ = qx{echo 'kitten'}; chomp; $_ }, 
                            expect => 'kitten',
                          },
               true    => { test => 1 },
             )

=cut

sub add {
   my $self = shift;
   my %cmds = @_;
   for my $name ( keys %cmds ) {

      if ( $self->can($name) ) {
         warn qq{there is already a test named $name, skipping.};
         next;
      }
      my $conf = $cmds{$name};

      { no strict;
        *{$self->{instance_class}} = sub{ my $_ = qx{$cmd}; chomp; assert_equal($_, $value, $note) };
      };

   }
}

sub run {}
sub summary {}
sub report {}

1;
