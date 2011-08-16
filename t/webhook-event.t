#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use Test::Fatal;
use Chargify::API;
use HTTP::Response;

BEGIN { use_ok("Chargify::Webhook::Event") }

chomp( my $RESPONSE = join "", <DATA> );
$RESPONSE = HTTP::Response->parse($RESPONSE);

$ENV{CHARGIFY_API_KEY} = "0HA1der2ChargifyApi-";
{
    ok( my $capi = Chargify::API->new(),
        "Chargify::API->new" );

    ok( my $cwe = Chargify::Webhook::Event->new( api => $capi,
                                                 response => $RESPONSE ),
        "Chargify::Webhook::Event->new" );

    is ( $cwe->event, "test", "Event type is test with API" );
}

# With key instead of API.
{
    ok( my $cwe = Chargify::Webhook::Event->new( key => "$ENV{CHARGIFY_API_KEY}",
                                                 response => $RESPONSE ),
        "Chargify::Webhook::Event->new with key" );

    is ( $cwe->event, "test", "Event type is test" );
}

# With key from ENV and single arg response.
{
    ok( my $cwe = Chargify::Webhook::Event->new( $RESPONSE ),
        "Chargify::Webhook::Event->new from plain response" );

    is ( $cwe->event, "test", "Event type is test" );
}

done_testing();

__DATA__
200 OK
Accept: */*; q=0.5, application/xml
Accept-Encoding: gzip, deflate
Content-Length: 36
Content-Type: application/x-www-form-urlencoded
X-Chargify-Webhook-Id: 657678
X-Chargify-Webhook-Signature: a308aa82241a3dcab03fe4186ab9224e

payload[chargify]=testing&event=test
