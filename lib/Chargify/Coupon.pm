package Chargify::Coupon;
use Mouse;
use namespace::autoclean;

# This is not yet comprehensive!
has [qw/ name code description /] =>
    is => "rw",
    isa => "Str",
    ;

has [qw/ allow_negative_balance recurring /] =>
    is => "rw",
    isa => "Bool",
    ;

has [qw/ percentage product_family_id /] =>
    is => "rw",
    isa => "Int",
    ;

has "end_date" =>
    is => "rw",
    # Needs coercion... isa => "DateTime",
    isa => "Str",
    required => 1,
    ;

has "product_family" =>
    is => "rw",
    isa => "Chargify::ProductFamily",
    lazy => 1,
    default => sub {},
    ;

__PACKAGE__->meta->make_immutable();

1;

__END__

=pod

=head1 Name

Chargify::Coupon - ...

=head1 Synopsis

=head1 Description

=over 4

=item *

=back

=head1 License, Author, and Disclaimer of Warranty

See L<Chargify::API>.

=cut

    https://<subdomain>.chargify.com/coupons


