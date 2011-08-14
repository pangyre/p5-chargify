#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use URI;
use YAML;
use Chargify::API;

plan skip_all => "Set CHARGIFY_API_KEY, CHARGIFY_SUBDOMAIN, *and* I_UNDERSTAND_THESE_RUN_AGAINST_CHARGIFY!"
    unless $ENV{CHARGIFY_API_KEY}
       and $ENV{CHARGIFY_SUBDOMAIN}
       and $ENV{I_UNDERSTAND_THESE_RUN_AGAINST_CHARGIFY};

ok( my $capi = Chargify::API->new( subdomain => $ENV{CHARGIFY_SUBDOMAIN} ),
    "Chargify::API->new with ENV" );

ok( my @transactions = $capi->call("transactions") );
note( YAML::Dump(\@transactions) );

ok( my @subscriptions = $capi->subscriptions );
# note( YAML::Dump(\@subscriptions) );

done_testing();

__DATA__

