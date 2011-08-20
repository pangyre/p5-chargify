#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use JSON;
BEGIN { use_ok("Chargify::ObjectifiedData") }

ok( my $data = decode_json(<DATA>), "Got test data" );
ok( $data->[0]->{subscription}, "Matches expectations" );

# my @objects;
for my $thing ( @{$data} )
{
    #note( $thing );
    ok( my ( $object ) = Chargify::ObjectifiedData->objectify_data( $thing ),
        "Chargify::ObjectifiedData->objectify_data..." );
    # push @objects, $object;
    isa_ok( $object, "Chargify::Subscription" );
    isa_ok( $object->customer, "Chargify::Customer" );
    isa_ok( $object->product, "Chargify::Product" );
    isa_ok( $object->product->product_family, "Chargify::ProductFamily" );
    isa_ok( $object->credit_card, "Chargify::CreditCard" );
    is( $object->customer->first_name, "Spendly",
        '$object->customer->first_name is right' );
    # is( $object->credit_card->masked_card_number, $/;
}

{
    my %customer = ( first_name => "Joe",
                     last_name => "Blow",
                     email => "joe\@example.com", );
    
    ok( my ( $customer ) = Chargify::ObjectifiedData->objectify_data({ customer => \%customer }),
        "Chargify::ObjectifiedData->objectify_data( customer data )" );
    is( $customer->email, 'joe@example.com',
        "Customer attributes looks right" );
}

done_testing();

__DATA__
[{"subscription":{"signup_revenue":"0.00","credit_card":{"customer_vault_token":null,"vault_token":"1","card_type":"bogus","current_vault":"bogus","expiration_year":2013,"billing_state":"NM","billing_city":"Taos","id":387362,"billing_address_2":"","masked_card_number":"XXXX-XXXX-XXXX-1","last_name":"McThriftson","expiration_month":1,"billing_zip":"87501","billing_country":"US","billing_address":"","customer_id":805540,"first_name":"Spendly"},"expires_at":null,"created_at":"2011-08-12T21:30:52-04:00","cancel_at_end_of_period":false,"activated_at":null,"delayed_cancel_at":null,"cancellation_message":null,"updated_at":"2011-08-12T21:30:52-04:00","trial_ended_at":"2012-08-12T21:30:52-04:00","signup_payment_id":6578760,"previous_state":"trialing","customer":{"reference":"fluffy","city":"","address":"","zip":"","created_at":"2011-08-12T21:27:40-04:00","country":"","updated_at":"2011-08-12T21:27:40-04:00","id":805540,"phone":"","last_name":"McThriftson","address_2":"","organization":"","state":"","first_name":"Spendly","email":"fluffy@example.com"},"id":804579,"canceled_at":null,"next_assessment_at":"2012-08-12T21:30:52-04:00","current_period_ends_at":"2012-08-12T21:30:52-04:00","trial_started_at":"2011-08-12T21:30:52-04:00","product":{"product_family":{"name":"Thneed","handle":"thneed","accounting_code":null,"id":12753,"description":"A thing everyone needs"},"name":"Ongoing Needling","return_params":"","handle":"thneedle","created_at":"2011-08-12T21:29:23-04:00","update_return_url":"","return_url":"","price_in_cents":100,"updated_at":"2011-08-12T21:29:23-04:00","trial_interval":12,"expiration_interval_unit":"never","expiration_interval":null,"accounting_code":"000001","initial_charge_in_cents":null,"id":48054,"require_credit_card":false,"trial_price_in_cents":0,"interval":1,"request_credit_card":false,"description":"You know, for kids.","archived_at":null,"trial_interval_unit":"month","interval_unit":"day"},"current_period_started_at":"2011-08-12T21:30:52-04:00","balance_in_cents":0,"state":"trialing"}}]

