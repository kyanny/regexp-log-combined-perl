use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Regexp::Log::Combined',
    AUTHOR              => 'Kensuke Kaneko <kyanny@gmail.com>',
    VERSION_FROM        => 'lib/Regexp/Log/Combined.pm',
    ABSTRACT_FROM       => 'lib/Regexp/Log/Combined.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Regexp::Log' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Regexp-Log-Combined-*' },
);
