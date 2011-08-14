#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use URI;
use Chargify::API;

plan skip_all => "Set CHARGIFY_API_KEY, CHARGIFY_SUBDOMAIN, *and* I_UNDERSTAND_THESE_RUN_AGAINST_CHARGIFY!"
    unless $ENV{CHARGIFY_API_KEY}
       and $ENV{CHARGIFY_SUBDOMAIN}
       and $ENV{I_UNDERSTAND_THESE_RUN_AGAINST_CHARGIFY};

ok( my $capi = Chargify::API->new( subdomain => $ENV{CHARGIFY_SUBDOMAIN} ),
    "Chargify::API->new with ENV" );

ok( my @subscriptions = $capi->subscriptions );

# use YAML; note( YAML::Dump(\@subscriptions) );
# diag( "CC: " . $subscriptions[0]->credit_card );

done_testing();

__DATA__

