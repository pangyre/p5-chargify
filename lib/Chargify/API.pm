# ABSTRACT: This is the worst part of Dist::Zilla.
package Chargify::API;
our $AUTHORITY = 'cpan:ASHLEY';
our $VERSION = "0.01-DEV";
use Mouse;
use namespace::autoclean;
use Mouse::Util::TypeConstraints "duck_type";
use Encode;
use JSON;
use MIME::Base64;
use Path::Class "file";
use Chargify::ObjectifiedData;

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;
    return $class->$orig(@_) unless @_ == 1;
    $class->$orig( api_key => $_[0] );
};

has "subdomain" =>
    is => "ro",
    isa => "Str",
    required => 1,
    lazy => 1,
    default => sub { "YOU-MUST-SET-THE-SUBDOMAIN" },
    ;

has "endpoint" =>
    is => "ro",
    isa => "URI::https",
    required => 1,
    lazy => 1,
    default => sub {
        my $self = shift;
        my $end = URI->new;
        $end->scheme("https");
        $end->host( $self->subdomain . ".chargify.com" );
        $end;
    },
    ;

has "api_key" =>
    is => "ro",
    isa => "Str",
    required => 1,
    lazy => 1,
    default => sub { $ENV{CHARGIFY_API_KEY} }
    ;

has "password" =>
    is => "ro",
    init_arg => undef,
    isa => "Str",
    required => 1,
    lazy => 1,
    default => sub { "x" },
    ;

has "agent" =>
    is => "rw",
    isa => duck_type(qw/ get post put /), # delete...is needed
    handles => [qw/ post put /],
    lazy => 1,
    required => 1,
    default => sub {
        my $self = shift;
        require WWW::Mechanize;
        WWW::Mechanize
            ->new( agent => join("/", __PACKAGE__, $VERSION),
                   protocols_allowed => [ "https" ],
                   timeout => 15,
                   # onerror => undef, # sub? logger?
                   stack_depth => 3,
                   headers => {
                       "Accept-Charset" => "utf-8",
                       "Accept" => "application/json",
                       "Authorization" => join(" ", "Basic",
                                               encode_base64( join(":", $self->api_key, $self->password ))),

                   },
                 );
    },
    ;

sub uri_for {
    my $uri = +shift->endpoint->clone;
    my $service_path = file(@_);
    $service_path or return;
    $uri->path($service_path);
    $uri;
}

sub get {
    my $self = shift;
    my $path = $self->uri_for(@_) || confess "No service arguments given";
    my $res = $self->agent->get($path);
    $res->code =~ /\A2\d\d\z/ or die $res->as_string;
    my ( $type, $charset ) = split /;\s*/, $res->header("Content-Type"), 2;
    my $content = decode( $charset, $res->content, Encode::FB_CROAK );
    my $data = decode_json($content);

    if ( ref $data eq "ARRAY" )
    {
        return map { Chargify::ObjectifiedData->objectify_data($_) } @{$data};
    }
    elsif ( ref $data eq "HASH" )
    {
        return Chargify::ObjectifiedData->objectify_data($data);
    }
    else
    {
        confess "get() returned unexpected data: ", $data;
    }
}

sub transactions { +shift->get("transactions", @_) }
sub subscriptions { +shift->get("subscriptions", @_) }
sub products { +shift->get("products", @_) }
sub customers { +shift->get("customers", @_) }

__PACKAGE__->meta->make_immutable();

__END__

=pod

=head1 Name

Chargify::API - ...

=head1 Synopsis

 # Use your own API key.
 my $capi = Chargify::API->new("0Ha1der2ChargifyApi-");

 my $capi = Chargify::API->new(api_key => "0Ha1der2ChargifyApi-",
                               subdomain => "mysite");

=head1 Description

E<hellip>

=over 4

=item *

=back

=head1 To Do

Plenty, includingE<ndash>

=head2 POSTs

=over 4

=item * /subscriptions

=item * /product_families/<x>/[component_type]

=item * /subscription/<x>/charges

=back

=head2 PUTs

=over 4

=item * /subscriptions/<x>

=back

=head2 DELETEs

=over 4

=item * /subscriptions/<x>

=back

L<http://docs.chargify.com/api-components>, L<http://docs.chargify.com/api-resources>.

=head1 Code Repository

L<http://github.com/pangyre/p5-chargify-api>.

=head1 See Also

E<hellip>

=head1 Author

Ashley Pond V E<middot> ashley@cpan.org E<middot> L<http://pangyresoft.com>.

=head1 License

You may redistribute and modify this package under the same terms as Perl itself.

=head1 Disclaimer of Warranty

Because this software is licensed free of charge, there is no warranty
for the software, to the extent permitted by applicable law. Except when
otherwise stated in writing the copyright holders and other parties
provide the software "as is" without warranty of any kind, either
expressed or implied, including, but not limited to, the implied
warranties of merchantability and fitness for a particular purpose. The
entire risk as to the quality and performance of the software is with
you. Should the software prove defective, you assume the cost of all
necessary servicing, repair, or correction.

In no event unless required by applicable law or agreed to in writing
will any copyright holder, or any other party who may modify or
redistribute the software as permitted by the above license, be
liable to you for damages, including any general, special, incidental,
or consequential damages arising out of the use or inability to use
the software (including but not limited to loss of data or data being
rendered inaccurate or losses sustained by you or third parties or a
failure of the software to operate with any other software), even if
such holder or other party has been advised of the possibility of
such damages.

=cut

# https://<subdomain>.chargify.com/<resource URI>
