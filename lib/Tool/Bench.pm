package Tool::Bench;
use Moose;
use Scalar::Util qw{looks_like_number};                                                                                                                               
use List::Util qw{min max};
use Benchmark::Stopwatch::Pause;

has results => (
   metaclass => 'Collection::Array',
   is        => 'ro',
   isa       => 'ArrayRef',
   lazy      => 1,
   default   => sub { [] },
   provides  => {
      push   => 'add_result',
   }
);

=head1 NAME

Tool::Bench - Stuff to make Benchmarking easy.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Tool::Bench;

    my $foo = Tool::Bench->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
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
