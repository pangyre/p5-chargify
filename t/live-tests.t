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

my %objects;
for my $service (qw/ products subscriptions transactions customers /)
{
    ok( my @obj = $capi->$service, blessed($capi) . "->$service" );
    $objects{$service} = \@obj;
    for my $obj ( @obj )
    {
        ok(blessed($obj), blessed($obj) . " is an object");
    }
}

# URL: https://<subdomain>.chargify.com/products/<id>.<format> 

for my $product ( @{ $objects{products} } )
{
    ok( my ( $product ) = $capi->call("products", $product->id),
        "Call product/" . $product->id );
    ok( $product->description,
        "Description: " . $product->description );
}

done_testing();

__DATA__

ok( my @transactions = $capi->call("transactions") );
note( YAML::Dump(\@transactions) );

ok( my @subscriptions = $capi->subscriptions );
# note( YAML::Dump(\@subscriptions) );
