package Chargify::Webhook::Listener;
use warnings;
use strict;
# No, maybe not... use parent qw( Plack::Component );

1;

__END__

Things this needs to do:

  * Receive events.
  * Create event objects.
    * Pass on pertinent info to event?
  * Serialize events?
    * Do something with the information such that its available to outside code.
    * OR have different models of operation.
