package Regexp::Log::Combined;

use warnings;
use strict;

use base qw(Regexp::Log);

our %DEFAULT = (
    format  => '%host %rfc %authuser %date %request %status %bytes %referer %useragent',
    capture => [qw(host rfc authuser date ts request req method resource proto status bytes referer ref useragent ua)]
);

our %FORMAT = (
    ':default'  => '%host %rfc %authuser %date %request %status %bytes %referer %useragent',
    ':common'   => '%host %rfc %authuser %date %request %status %bytes',
    ':combined' => '%host %rfc %authuser %date %request %status %bytes %referer %useragent',
    ':extended' => '%host %rfc %authuser %date %request %status %bytes %referer %useragent',
);

our %REGEXP = (
    '%host'      => '(?#=host)\S+(?#!host)', # numeric or name of remote host
    '%rfc'       => '(?#=rfc).*?(?#!rfc)', # rfc931
    '%authuser'  => '(?#=authuser).*?(?#!authuser)', # authuser
    '%date'      => '(?#=date)\[(?#=ts)\d{2}\/\w{3}\/\d{4}(?::\d{2}){3} [-+]\d{4}(?#!ts)\](?#!date)', # [date] (see note)
    '%request'   => '(?#=request)\"(?#=req)(?#=method)\S+(?#!method) (?#=resource)\S+(?#!resource) (?#=proto)\S+(?#!proto)(?#!req)\"(?#!request)', # "request"
    '%status'    => '(?#=status)\d+(?#!status)', # status
    '%bytes'     => '(?#=bytes)-|\d+(?#!bytes)', # bytes
    '%referer'   => '(?#=referer)\"(?#=ref).*?(?#!ref)\"(?#!referer)', # "referer"
    '%useragent' => '(?#=useragent)\"(?#=ua).*?(?#!ua)\"(?#!useragent)', # "user_agent"
);

# note: date is in the format [01/Jan/1997:13:07:21 -0600]

=head1 NAME

Regexp::Log::Combined - A regular expression parser for the Common Log Format

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    my $foo = Regexp::Log::Combined->new(
        format => ':combined',
        capture => 'ts method resource proto',
    );

    my @fields = $foo->capture;

    my $re = $foo->regexp;

    while (<>) {
        my %data;
        @data{@fields} = /$re/;
    }


=head1 DESCRIPTION

Regexp::Log::Combined is subclass of Regexp::Log.
This module provides a regular expression for parse Common Log Format,
includes Extended (combined) log format.

This module is inspired by Regexp::Log::Common.
Difference between these two modules is variation of captured fields.
Regexp::Log::Combined can capture request string separately.
You can get request string as three patrs, $method, $resource, and $proto.

=head1 SEE ALSO

L<Regexp::Log>, L<Regexp::Log::Common>

=head1 AUTHOR

Kensuke Kaneko, C<< <kyanny at gmail.com> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Kensuke Kaneko, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Regexp::Log::Combined
