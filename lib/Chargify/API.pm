# ABSTRACT: This is the worst part of Dist::Zilla.
package Chargify::API;
our $AUTHORITY = 'cpan:ASHLEY';
our $VERSION = "0.01-DEV";
use Mouse;
use Mouse::Util::TypeConstraints "duck_type";

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;
    return $class->$orig(@_) unless @_ == 1;
    $class->$orig( api_key => $_[0] );
};

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
    default => sub { "x" },
    ;

has "agent" =>
    is => "rw",
    isa => duck_type(qw/ get post put delete /),
    handles => [qw/ get post put delete /],
    lazy => 1,
    required => 1,
    default => sub {
        require WWW::Mechanize;
        WWW::Mechanize
            ->new( agent => join("/", __PACKAGE__, $VERSION),
                   protocols_allowed => [ "https" ],
                   timeout => 15,
                   onerror => undef,
                   stack_depth => 3,
                   headers => {
                       "Accept-Charset" => "utf-8",
                       "Accept" => "application/json"
                   },
                 );
        # $agent->add_header(...);
    },
    ;

__PACKAGE__->meta->make_immutable();

__END__

=pod

=head1 Name

Chargify::API - ...

=head1 Synopsis

 # Use your own API.
 my $capi = Chargify::API->new("0Ha1der2ChargifyApi-");

=head1 Description

=over 4

=item *

=back

=head1 Code Repository

L<http://github.com/pangyre/p5-chargify-api>.

=head1 See Also

E<hellip>

=head1 Author

Ashley Pond V E<middot> ashley.pond.v@gmail.com E<middot> L<http://pangyresoft.com>.

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

https://<subdomain>.chargify.com/<resource URI>

my %coders = (
              "application/json" => {
                                     serialize => \&JSON::XS::encode_json,
                                     marshal => \&JSON::XS::decode_json,
                                    },
             );

request must add accept headers

  'User-Agent' => 'Mozilla/4.76 [en] (Win98; U)',
  'Accept-Language' => 'en-US',
  'Accept-Charset' => 'iso-8859-1,*,utf-8',
  'Accept-Encoding' => 'gzip',
  'Accept' =>
   "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, image/png, */*",

