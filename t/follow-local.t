use warnings;
use strict;
use Test::More tests => 14;
use lib 't/lib';
use Test::HTTP::LocalServer;
my $server = Test::HTTP::LocalServer->spawn;

BEGIN {
    use_ok( 'WWW::Mechanize' );
}

my $agent = WWW::Mechanize->new;
isa_ok( $agent, 'WWW::Mechanize', 'Created object' );
$agent->quiet(1);

$agent->get( $server->url );
ok( $agent->success, 'Got some page' );
is( $agent->uri, $server->url, 'Got local server page' );

ok(! $agent->follow(99999), "Can't follow too-high-numbered link");

ok($agent->follow(1), "Can follow first link");
isnt( $agent->uri, $server->url, 'Need to be on a separate page' );

ok($agent->back(), "Can go back");
is( $agent->uri, $server->url, 'Back at the first page' );

ok(! $agent->follow(qr/asdfghjksdfghj/), "Can't follow unlikely named link");

ok($agent->follow("Link /foo"), "Can follow obvious named link");
isnt( $agent->uri,$server->url, 'Need to be on a separate page' );

ok($agent->back(), "Can still go back");
is( $agent->uri, $server->url, 'Back at the start page again' );