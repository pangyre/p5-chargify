package Chargify::Webhook::Event;
use Mouse;
use namespace::autoclean;
use Digest::MD5 "md5_hex";
use URI::Escape "uri_unescape";
use Mouse::Util::TypeConstraints "duck_type", "enum", "class_type";

class_type "Chargify::API";

enum "CWE" =>
    "test",
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
    ;

has "key" =>
    is => "ro",
    isa => "Str",
    required => 1,
    lazy => 1,
    default => sub { $_[0]->api ? $_[0]->api->key : $ENV{CHARGIFY_API_KEY} },
    ;

has "event" =>
    is => "ro",
    writer => "_set_event",
    isa => "CWE",
    required => 1,
    lazy => 1,
    default => sub { +shift->param("event") },
    ;

has "response" =>
    is => "ro",
    isa => duck_type(qw/ decoded_content header /),
    required => 1,
    ;

has "params" =>
    traits    => ["Hash"],
    is        => "ro",
    isa       => "HashRef[Str]",
    default   => sub { {} },
    handles   => {
        set_param => "set",
        param => "get",
    },
    ;

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;
    return $class->$orig(@_) unless @_ == 1;
    $class->$orig( response => $_[0] );
};

sub BUILD {
    my $self = shift;
    my $args = shift;

    # Return exception instead?
    my $header = $self->response->header("X-Chargify-Webhook-Signature");
    my $validation = md5_hex( $self->key, $self->response->decoded_content );
    $header eq $validation
        or confess "Invalid signature, X-Chargify-Webhook-Signature: $header ne $validation";

    my $ct = $self->response->header("Content-Type");
    $ct =~ m,application/x-www-form-urlencoded,
        or confess "Cannot handle any this content type: $ct";

    for my $pair ( split '&|;', $self->response->decoded_content )
    {
        my ( $key, $val ) = map { uri_unescape($_) } split '=', $pair, 2;
        $self->set_param( $key => $val )
    }
};

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
