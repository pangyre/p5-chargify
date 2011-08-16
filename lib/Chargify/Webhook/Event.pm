package Chargify::Webhook::Event;
use Mouse;
use Digest::MD5 "md5_hex";
use namespace::autoclean;
#  * Authenticate posts: MD5::hexdigest(site.shared_key + webhook.body)
use Mouse::Util::TypeConstraints;
class_type "Chargify::API";
enum "CWE" =>
    "Payment Success",
    "Payment Failure",
    "Signup Success",
    "Signup Failure",
    "Billing Date Change",
    "Renewal Success",
    "Renewal Failure",
    "Subscription State Change",
    "Subscription Product Change",
    "Expiring Card",
    ;

has "api" =>
    is => "ro",
    isa => "Chargify::API",
    required => 1,
    ;

has "event" =>
    is => "ro",
    isa => "CWE",
    required => 1,
    lazy => 1,
    default => sub { confess "No event was set" },
    ;

use overload '""' => sub { +shift->event }, fallback => 1;

1;

__END__
Ports other than 80/443 appear to fail.

body: payload[chargify]=testing&event=test
headers: 
  Content-Type: application/x-www-form-urlencoded
  X-Chargify-Webhook-Signature: 7d02f2402ce7b9e2fb4a42dd5cd74ca7
  Content-Length: "36"
  Accept-Encoding: gzip, deflate
  Accept: "*/*; q=0.5, application/xml"
  X-Chargify-Webhook-Id: "657646"

    Webhooks subscriptions
      Payment Success
      Payment Failure
      Signup Success
      Signup Failure
      Billing Date Change
      Renewal Success
      Renewal Failure
      Subscription State Change
      Subscription Product Change
      Expiring Card
