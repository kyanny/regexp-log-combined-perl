use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Regexp::Log::Combined',
    license             => 'perl',
    dist_author         => 'Kensuke Kaneko <kyanny@gmail.com>',
    dist_version_from   => 'lib/Regexp/Log/Combined.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Regexp-Log-Combined-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
