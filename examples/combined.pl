#!/usr/bin/perl
use strict;
use warnings;

use FindBin;
use File::Spec;
use lib File::Spec->catdir($FindBin::Bin, qw(.. lib));

use Regexp::Log::Combined;
use Data::Dumper;

my $foo = Regexp::Log::Combined->new(
    format => ':combined',
    capture => [qw( host rfc authuser date ts request req method resource proto status bytes referer ref useragent ua )],
);

my @fields = $foo->capture;
my $re = $foo->regexp;

open my $fh, '<', File::Spec->catfile($FindBin::Bin, qw(.. t combined.log));

while (<$fh>) {
    chomp;
    my %data;
    @data{@fields} = /$re/;
    print Dumper \%data;
}

close $fh;
