use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Tool::Bench',
    license             => 'perl',
    dist_author         => q{ben hengst <notbenh@cpan.org>},
    dist_version_from   => 'lib/Tool/Bench.pm',
    build_requires => {
        'Capture::Tiny' => 0,
        'Test::More' => 0,
        'Test::Most' => 0,
        'POSIX'      => 0,
        'List::Util' => 0,
        'Moose'      => 0,
        'MooseX::AttributeHelpers' => 0,
        'Benchmark::Stopwatch::Pause' => 0,
    },
    add_to_cleanup      => [ 'Tool-Bench-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
