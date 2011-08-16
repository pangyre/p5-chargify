#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use Test::Fatal;
use Chargify::API;
use HTTP::Response;

BEGIN { use_ok("Chargify::Webhook::Event") }

{
    ok( my $capi = Chargify::API->new( key => "0HA1der2ChargifyApi-"),
        "Chargify::API->new" );
    
    chomp( my $response = join "", <DATA> );
    $response = HTTP::Response->parse($response);

    ok( my $cwe = Chargify::Webhook::Event->new( api => $capi,
                                                 response => $response ),
        "Chargify::Webhook::Event->new" );
    is ( $cwe->event, "test",
         "Event type is test" );

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
