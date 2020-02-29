#!perl -T
use 5.008;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Jo::Util' ) || print "Bail out!\n";
}

diag( "Testing Jo::Util $Jo::Util::VERSION, Perl $], $^X" );
