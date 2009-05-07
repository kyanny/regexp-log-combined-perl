use Test::More tests => 46;
use strict;
use Regexp::Log::Common;
use IO::File;

my @list1 = qw(host rfc authuser);
my @list2 = qw(host rfc authuser date request status bytes);
my @list3 = qw(host rfc authuser date request status bytes referer useragent);
my @list4 = qw(host rfc authuser date ts request req status bytes referer ref useragent ua);
my @list5 = qw(host rfc authuser date ts request req status bytes);
my $form1 = join(' ',map { '%'.$_ } @list1);
my $form2 = join(' ',map { '%'.$_ } @list2);
my $form3 = join(' ',map { '%'.$_ } @list3);

my $foo = Regexp::Log::Common->new();
isa_ok($foo, 'Regexp::Log::Common');

# check defaults
is( $foo->format , $form3, "Default format" );
my @capture = $foo->capture;
is( @capture , 13, "Default capture" );
is( $capture[6] , 'req', "Default captured field" );
is( $foo->comments , 0, "Default comments" );

# check the format method
is( $foo->format($form1) , $form1, "Format return new value" );
is( $foo->format , $form1, "new format value is set" );

# check other formats
$foo = Regexp::Log::Common->new(format => ':default');
is( $foo->format , $form2, "Default format" );
$foo = Regexp::Log::Common->new(format => ':common');
is( $foo->format , $form2, "Common format" );
$foo = Regexp::Log::Common->new(format => ':extended');
is( $foo->format , $form3, "Extended format" );

# check the fields method
my @fields = sort $foo->fields;
my $i      = 0;
for (sort @list4) {
    is( $fields[ $i++ ] , $_, "Found field $_" );
}

# set the captures
@fields = $foo->capture(':none');
is( @fields , 0, "Capture :none" );
@fields = $foo->capture(':all');
is( @fields , @list4, "Capture :all" );

@fields = sort $foo->capture(qw( :none date request ));
is( @fields , 2, "Capture only two fields" );
$i = 0;
for (qw( date request )) {
    is( $fields[ $i++ ] , $_, "Field $_ is captured" );
}

$foo = Regexp::Log::Common->new(format => '%date %authuser %rfc');
@fields = sort $foo->capture;
$i      = 0;
for (qw(authuser date rfc )) {
    is( $fields[ $i++ ] , $_, "Field $_ is captured by :default" );
}

# the comments method
is( $foo->comments(1) , 1, "comments old value" );
is( $foo->comments , 1, "comments new value" );

# the regexp method
is( $foo->regex , $foo->regexp, "regexp() is aliased to regex()" );

$foo->comments(0);
my $regexp = $foo->regexp;
ok( $regexp !~ /\(\?\#.*?\)/, "No comment in regexp" );
$foo->comments(1);

$foo->format('%date');
is( @{ [ $foo->regexp =~ /(\(\?\#.*?\))/g ] } , 4,
    "4 comments for %date in regexp" );
$foo->format('%authuser');
is( @{ [ $foo->regexp =~ /(\(\?\#.*?\))/g ] } , 2,
    "2 comments for %authuser in regexp" );
$foo->comments(0);

# test the regex on real CLF log lines
$foo = Regexp::Log::Common->new(format => ':common');
@fields = $foo->capture(":common");
is( @fields , @list5, "Capture :common" );
$regexp = $foo->regexp;

my %data;
my @data = (
    {
		host => '127.0.0.1',
		rfc => '-',
		authuser => '-',
		date => '[19/Jan/2005:21:42:43 +0000]',
		ts => '19/Jan/2005:21:42:43 +0000',
		request => '"POST /cgi-bin/brum.pl?act=evnt-edit&eventid=24 HTTP/1.1"',
		req => 'POST /cgi-bin/brum.pl?act=evnt-edit&eventid=24 HTTP/1.1',
		status => 200,
		bytes => 11435
    },
    {
		host => '127.0.0.1',
		rfc => '-',
		authuser => '-',
		date => '[19/Jan/2005:21:43:29 +0000]',
		ts => '19/Jan/2005:21:43:29 +0000',
		request => '"GET /images/perl_id_313c.gif HTTP/1.1"',
		req => 'GET /images/perl_id_313c.gif HTTP/1.1',
		status => 304,
		bytes => 0
    },
    {
		host => '127.0.0.1',
		rfc => '-',
		authuser => '-',
		date => '[19/Jan/2005:21:47:11 +0000]',
		ts => '19/Jan/2005:21:47:11 +0000',
		request => '"GET /brum.css HTTP/1.1"',
		req => 'GET /brum.css HTTP/1.1',
		status => 304,
		bytes => 0
    },
    {
		host => '127.0.0.1',
		rfc => '-',
		authuser => '-',
		date => '[19/Jan/2005:21:47:11 +0000]',
		ts => '19/Jan/2005:21:47:11 +0000',
		request => '"GET /brum.css HTTP/1.1"',
		req => 'GET /brum.css HTTP/1.1',
		status => 304,
		bytes => '-'
    },
);

my $fh = IO::File->new('t/common.log');
$i = 0;
while (<$fh>) {
    @data{@fields} = /$regexp/;
    is_deeply( \%data, $data[ $i++ ], "common.log line " . ( $i + 1 ) );
}
$fh->close;

# test the regex on real ECLF log lines
$foo = Regexp::Log::Common->new(format => ':extended');
@fields = $foo->capture(":extended");
is( @fields , @list4, "Capture :extended" );
$regexp = $foo->regexp;

%data = ();
@data = (
    {
		host => '127.0.0.1',
		rfc => '-',
		authuser => '-',
		date => '[19/Jan/2005:21:42:43 +0000]',
		ts => '19/Jan/2005:21:42:43 +0000',
		request => '"POST /cgi-bin/brum.pl?act=evnt-edit&eventid=24 HTTP/1.1"',
		req => 'POST /cgi-bin/brum.pl?act=evnt-edit&eventid=24 HTTP/1.1',
		status => 200,
		bytes => 11435,
		referer => '"http://birmingham.pm.org/"',
		ref => 'http://birmingham.pm.org/',
		useragent => '"Mozilla/2.0GoldB1 (Win95; I)"',
		ua => 'Mozilla/2.0GoldB1 (Win95; I)',
    },
    {
		host => '127.0.0.1',
		rfc => '-',
		authuser => '-',
		date => '[19/Jan/2005:21:43:29 +0000]',
		ts => '19/Jan/2005:21:43:29 +0000',
		request => '"GET /images/perl_id_313c.gif HTTP/1.1"',
		req => 'GET /images/perl_id_313c.gif HTTP/1.1',
		status => 304,
		bytes => 0,
		referer => '"http://birmingham.pm.org/"',
		ref => 'http://birmingham.pm.org/',
		useragent => '"Mozilla/2.0GoldB1 (Win95; I)"',
		ua => 'Mozilla/2.0GoldB1 (Win95; I)',
    },
    {
		host => '127.0.0.1',
		rfc => '-',
		authuser => '-',
		date => '[19/Jan/2005:21:47:11 +0000]',
		ts => '19/Jan/2005:21:47:11 +0000',
		request => '"GET /brum.css HTTP/1.1"',
		req => 'GET /brum.css HTTP/1.1',
		status => 304,
		bytes => 0,
		referer => '"http://birmingham.pm.org/"',
		ref => 'http://birmingham.pm.org/',
		useragent => '"Mozilla/2.0GoldB1 (Win95; I)"',
		ua => 'Mozilla/2.0GoldB1 (Win95; I)',
    },
);

$fh = IO::File->new('t/extended.log');
$i = 0;
while (<$fh>) {
    @data{@fields} = /$regexp/;
    is_deeply( \%data, $data[ $i++ ], "extended.log line " . ( $i + 1 ) );
}
$fh->close;

