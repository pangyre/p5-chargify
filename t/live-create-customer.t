#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use URI;
use YAML;
use Chargify::API;
use Scalar::Util "blessed";

plan skip_all => "Set CHARGIFY_API_KEY, CHARGIFY_SUBDOMAIN, *and* I_UNDERSTAND_THESE_RUN_AGAINST_CHARGIFY!"
    unless $ENV{CHARGIFY_API_KEY}
       and $ENV{CHARGIFY_SUBDOMAIN}
       and $ENV{I_UNDERSTAND_THESE_RUN_AGAINST_CHARGIFY};

ok( my $capi = Chargify::API->new( subdomain => $ENV{CHARGIFY_SUBDOMAIN} ),
    "Chargify::API->new with ENV" );

# Create a customer... must be manually checked and removed at this point.
{
    my ( $customer ) = Chargify::ObjectifiedData
        ->objectify_data({ customer => {
                                        first_name => "Marcus",
                                        last_name => "Welby",
                                        email => "dr.dr\@example.com",
                                       }
                         });
    ok( my $res = $capi->create($customer),
        "Created customer" );
}

# URL: https://<subdomain>.chargify.com/subscriptions/<subscription_id>/components.<format>

done_testing();

__DATA__

ok( my @transactions = $capi->get("transactions") );
note( YAML::Dump(\@transactions) );

ok( my @subscriptions = $capi->subscriptions );
# note( YAML::Dump(\@subscriptions) );
