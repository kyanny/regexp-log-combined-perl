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
     capture => [qw( host rfc authuser date ts request req method resource proto status bytes referer ref useragent ua )],
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

=head1 LOG FORMATS

=head2 Common Log Format

 my $foo = Regexp::Log::Combined->new( format => ':common' );

=over

=item * Fields

 remotehost rfc931 authuser [date] "request" status bytes

=item * Example

 127.0.0.1 - - [19/Jan/2005:21:47:11 +0000] "GET /brum.css HTTP/1.1" 304 0

 remotehost: 127.0.0.1
 rfc931: -
 authuser: -
 [date]: [19/Jan/2005:21:47:11 +0000]
 "request": "GET /brum.css HTTP/1.1"
 status: 304
 bytes: 0

=item * Available Capture Fields

 * host
 * rfc
 * authuser
 * date
 ** ts (date without [])
 * request
 ** req (request without the quotes)
 *** method (part of req)
 *** resource (part of req)
 *** proto (part of req)
 * status
 * bytes

=back

=head2 Extended Common Log Format (combined)

 my $foo = Regexp::Log::Combined->new( format => ':combined' );

=over

=item * Fields

 remotehost rfc931 authuser [date] "request" status bytes "referer" "user_agent"

=item * Example

 127.0.0.1 - - [19/Jan/2005:21:47:11 +0000] "GET /brum.css HTTP/1.1" 304 0 "http://birmingham.pm.org/" "Mozilla/2.0GoldB1 (Win95; I)"

 remotehost: 127.0.0.1
 rfc931: -
 authuser: -
 [date]: [19/Jan/2005:21:47:11 +0000]
 "request": "GET /brum.css HTTP/1.1"
 status: 304
 bytes: 0
 "referer": "http://birmingham.pm.org/"
 "user_agent": "Mozilla/2.0GoldB1 (Win95; I)"

=item * Available Capture Fields

 * host
 * rfc
 * authuser
 * date
 ** ts (date without [])
 * request
 ** req (request without the quotes)
 *** method (part of req)
 *** resource (part of req)
 *** proto (part of req)
 * status
 * bytes
 * referer
 ** ref (referer without the quotes)
 * useragent
 ** ua (useragent without the quotes)

=back

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
