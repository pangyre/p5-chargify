package Chargify::Webhook::Listener;
use warnings;
use strict;
# No, maybe not... use parent qw( Plack::Component );

1;

__END__

Things this needs to do:

  * Authenticate posts: MD5::hexdigest(site.shared_key + webhook.body)
    * X-Chargify-Webhook-Signature

  * Do something with the information such that its available to outside code.
    * OR have different models of operation.


    Webhooks enabled?
      Send Webhooks to my Webhook URL
    Webhook URL
