#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Regexp::Log::Combined' );
}

diag( "Testing Regexp::Log::Combined $Regexp::Log::Combined::VERSION, Perl $], $^X" );
