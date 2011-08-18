#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use JSON;
use Chargify::ObjectifiedData;

BEGIN { use_ok("Chargify::Coupon") }

local $/;
ok( my $data = decode_json(<DATA>), "Got test data" );


ok( my ( $coupon ) = Chargify::Coupon->new( $data->{coupon} ),
    'Chargify::Coupon->new($coupon_data)' );

ok( my ( $coupon2 ) = Chargify::ObjectifiedData->objectify_data( $data ),
    'Chargify::ObjectifiedData->objectify_data($coupon_data)' );

is_deeply( $coupon, $coupon2,
           "Chargify::Coupon eq Chargify::ObjectifiedData" );

subtest "Attribute methods match data" => sub {
    plan tests => scalar keys %{ $data->{coupon} };

    for my $attr ( keys %{ $data->{coupon} } )
    {
        is( $coupon->$attr, $data->{coupon}{$attr},
            "$attr -> " . $coupon->$attr );
    }
};

done_testing();

__DATA__
{
    "coupon": {
           "name": "15% off",
           "code": "15OFF",
           "description": "15% off for life",
           "percentage": 15,
           "allow_negative_balance": false,
           "recurring": false,
           "end_date": "2012-08-29T12:00:00-04:00",
           "product_family_id": 2
    }
}
