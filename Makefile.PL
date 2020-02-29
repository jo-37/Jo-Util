use 5.008;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Jo::Util',
    AUTHOR           => q{Jörg Sommrey <28217714+jo-37@users.noreply.github.com>},
    VERSION_FROM     => 'lib/Jo/Util.pm',
    ABSTRACT_FROM    => 'lib/Jo/Util.pm',
    LICENSE          => 'Perl_5',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.008,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
		'Test2::V0' => 0,
    },
    PREREQ_PM => {
        'Exporter::Tiny' => 0,
		'Carp' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Jo-Util-*' },
);
