package Tool::Bench;

# ABSTRACT: easy benching
BEGIN {
   $ENV{TEST_MINI_NO_AUTORUN} => 1; # disable some of Test::Mini's auto-magic
};

use Mouse;
use Mouse::Util::TypeConstraints;

subtype 'Instance' => as 'Object';
coerce  'Instance' 
   => from 'Str'
      => via { eval qq{require $_};  
               # should probably check for the right methods and if it's mouse based?
               $_->new 
             };

has instance =>
   is => 'rw',
   isa => 'Instance',
   default => sub{ 
      require Tool::Bench::Instance;
      Tool::Bench::Instance->new;
   },
;

has runner => 
   is => 'rw',
   isa => 'Test::Mini::Runner',
   default => sub{
      require Test::Mini::Runner;
      require Test::Mini::Logger::TAP;
      Test::Mini::Runner->new;
   },
;

has tests => 
   is => 'rw',
   isa => 'ArrayRef',
   default => sub{[]},
;

=method add

  $bench->add( simple => { test    => 3,
                           expect  => 3,
                           note    => 'defaults to the $name if this key is not specified',
                         },
               system => { command => q{echo 'kitten'}, 
                           expect  => 'kitten',
                         },
               true   => { test    => 1 },
             )

=cut

sub add {
   my $self = shift;
   my %cmds = @_;

   sub command { 
      my $cmd = shift;
      sub{my $_ = qx{$cmd}; chomp; $_};
   };

   for my $name ( keys %cmds ) {

      if ( $self->instance->can($name) ) {
         warn qq{there is already a test named $name, skipping.};
         next;
      }
      my $conf = $cmds{$name};

      my $got = defined $conf->{command} ? command($conf->{command})
              : defined $conf->{test}    ? sub{$conf->{test}}
              :                            undef ;
      my $note= $conf->{note} || $name; 

      $self->instance->meta->add_method( $name => defined $conf->{expect} 
                                                ? sub{ assert_equal(&$got,$conf->{expect}, $note) }
                                                : sub{ assert      ($got ,$note)                  }
                                       );
      push @{$self->tests}, $name;
   }
   $self->tests;
}

sub run { 
   my $self = shift;
   $self->runner->{logger} = $self->runner->{logger}->new
      unless ref($self->runner->{logger});
      
   $self->runner->run_test_case($self->instance, @{$self->tests});
}
sub results {}
sub report {}





no Mouse;
no Mouse::Util::TypeConstraints;
1;
