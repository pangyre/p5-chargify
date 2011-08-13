#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use Test::Fatal;

BEGIN { use_ok("Chargify::API") }

{
    local $ENV{CHARGIFY_API_KEY};
    ok( my $capi = Chargify::API->new,
        "Chargify::API->new with clean ENV");

    isnt( exception { $capi->api_key },
          undef,
          "api_key is required or fatal",
        );
}

done_testing();

__DATA__
