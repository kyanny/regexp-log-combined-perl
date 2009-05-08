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
    '%host' => '(?#=host)\S+(?#!host)', # numeric or name of remote host
    '%rfc' => '(?#=rfc).*?(?#!rfc)',    # rfc931
    '%authuser' => '(?#=authuser).*?(?#!authuser)', # authuser
    '%date' => '(?#=date)\[(?#=ts)\d{2}\/\w{3}\/\d{4}(?::\d{2}){3} [-+]\d{4}(?#!ts)\](?#!date)', # [date] (see note)
    '%request' => '(?#=request)\"(?#=req)(?#=method)\S+(?#!method) (?#=resource)\S+(?#!resource) (?#=proto)\S+(?#!proto)(?#!req)\"(?#!request)', # "request"
    '%status' => '(?#=status)\d+(?#!status)',    # status
    '%bytes' => '(?#=bytes)-|\d+(?#!bytes)',     # bytes
    '%referer' => '(?#=referer)\"(?#=ref).*?(?#!ref)\"(?#!referer)', # "referer"
    '%useragent' => '(?#=useragent)\"(?#=ua).*?(?#!ua)\"(?#!useragent)', # "user_agent"
);

# note: date is in the format [01/Jan/1997:13:07:21 -0600]

=head1 NAME

Regexp::Log::Combined -

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS


=head1 EXPORT


=head1 FUNCTIONS

=head1 AUTHOR

Kensuke Kaneko, C<< <kyanny at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-regexp-log-combined at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Regexp-Log-Combined>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Regexp::Log::Combined


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Regexp-Log-Combined>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Regexp-Log-Combined>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Regexp-Log-Combined>

=item * Search CPAN

L<http://search.cpan.org/dist/Regexp-Log-Combined>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Kensuke Kaneko, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Regexp::Log::Combined
