#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use JSON;
use Chargify::ObjectifiedData;
# perl -CO -MYAML -MJSON -e 'print YAML::Dump decode_json q|{"key":"\u00df\u00f8\u00b5\u00e9"}|'
# https://pangyresoft.chargify.com/product_families/12753/products/new

local $/;
ok( my $data = decode_json(<DATA>), "Got test data" );
ok( $data->[0]->{product}, "Matches expectations" );

for my $thing ( @{$data} )
{
    # note( $thing );
    ok( my ( $object ) = Chargify::ObjectifiedData->objectify_data( $thing ),
        "Chargify::ObjectifiedData->objectify_data..." );
    isa_ok( $object, "Chargify::Product" );
    isa_ok( $object->product_family, "Chargify::ProductFamily" );
    note( $object->description );
    use Encode;
    note( encode("UTF-8", $object->product_family->description) );
}

done_testing();

__DATA__
[{"product":{"product_family":{"name":"Thneed","handle":"thneed","accounting_code":null,"id":12753,"description":"A thing everyone needs"},"name":"Ongoing Needling","return_params":"","handle":"thneedle","created_at":"2011-08-12T21:29:23-04:00","update_return_url":"","return_url":"","price_in_cents":100,"updated_at":"2011-08-12T21:29:23-04:00","trial_interval":12,"expiration_interval_unit":"never","expiration_interval":null,"accounting_code":"000001","initial_charge_in_cents":null,"id":48054,"require_credit_card":false,"trial_price_in_cents":0,"interval":1,"request_credit_card":false,"description":"You know, for kids.","archived_at":null,"trial_interval_unit":"month","interval_unit":"day"}},{"product":{"product_family":{"name":"Thneed","handle":"thneed","accounting_code":null,"id":12753,"description":"A thing everyone needs"},"name":"Wheedle","return_params":"","handle":"wheedle","created_at":"2011-08-17T01:05:17-04:00","update_return_url":"","return_url":"","price_in_cents":9900,"updated_at":"2011-08-17T01:05:17-04:00","trial_interval":null,"expiration_interval_unit":"never","expiration_interval":null,"accounting_code":"wheedle2000","initial_charge_in_cents":100000,"id":48277,"require_credit_card":true,"trial_price_in_cents":0,"interval":1,"request_credit_card":true,"description":"For all your wheelding needs.","archived_at":null,"trial_interval_unit":"month","interval_unit":"month"}},{"product":{"product_family":{"name":"Software Services","handle":"saas","accounting_code":null,"id":12815,"description":"\u00df\u00f8\u00b5\u00e9 services relating to softwarz."},"name":"Bug fixings","return_params":"","handle":"advanced_api_handle_is_what_now","created_at":"2011-08-17T01:15:35-04:00","update_return_url":"","return_url":"","price_in_cents":42,"updated_at":"2011-08-17T01:15:35-04:00","trial_interval":null,"expiration_interval_unit":"month","expiration_interval":24,"accounting_code":"bugz","initial_charge_in_cents":null,"id":48278,"require_credit_card":true,"trial_price_in_cents":0,"interval":1,"request_credit_card":true,"description":"Up in your code, fixing yer bugz.","archived_at":null,"trial_interval_unit":"month","interval_unit":"month"}}]
