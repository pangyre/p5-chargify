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

    isnt( exception { $capi->key },
          undef,
          "key is required or fatal",
        );
}

{
    local $ENV{CHARGIFY_API_KEY} = "0HA1der2ChargifyApi-";
    ok( my $capi = Chargify::API->new,
        "Chargify::API->new with ENV");
    is( exception { $capi->key },
        undef,
        "key is populated from CHARGIFY_API_KEY",
      );
}

# Some security vetting...
{
    ok( my $capi = Chargify::API->new(key => "0Ha1der2ChargifyApi-",
                                      subdomain => "mysite"),
        "New with key and subdomain" );

    isnt( exception { $capi->get("http://example.org") },
          undef,
          "Request with http protocol is fatal",
        );
}

done_testing();

__DATA__

