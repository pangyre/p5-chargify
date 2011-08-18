package Chargify::ObjectifiedData;
use strict;
use warnings;
use Carp;
use Scalar::Util "blessed";

sub _load_class_with_attributes {
    my ( $class, @attributes ) = @_;
    $class or confess "No class given";

    # If we have it defined, use that, don't generate the package.
    eval { require $class; 1 } and return 1;

    # MAYBE this should use ->meta to inspect and add missing attributes?

    my $attr_str = join(" ", @attributes);
    eval <<"PackageInstantiation";
    {
      package $class;
      use Mouse;

      has "api" =>
          is => "ro",
          writer => "set_api",
          isa => "Chargify::API",
          weak_ref => 1,
          ;

      # Parent? Instead

      has [qw/ $attr_str /] =>
          is => "ro",
          ;

      sub loaded { 1 }

      __PACKAGE__->meta->make_immutable();
    }
PackageInstantiation
    $@ and confess $@;
}

# This needs reorganization so there is no $package duplication and so
# that context can load array refs into the attributes where
# appropriate.

sub objectify_data {
    my $class = shift;
    my $args = shift || die "No args";
    my @objects;
    for my $name ( keys %{ $args } )
    {
        my $package = "Chargify::" . _camel_convert($name);
        push @objects, _curry_data_to_object_tree($package, $args->{$name});
    }
    @objects;
}

sub _curry_data_to_object_tree {
    my ( $class, $args ) = @_;

    my @attributes = keys %{ $args };
    if ( $class and not eval { $class->loaded } )
    {
        _load_class_with_attributes( $class, @attributes );
    }

    for my $name ( keys %{$args} )
    {
        if ( ref($args->{$name}) eq "HASH" )
        {
            # Convert in place to object, or array ref of them.
            my $package = "Chargify::" . _camel_convert($name);
            $args->{$name} = _curry_data_to_object_tree($package, $args->{$name});
        }
        elsif ( ref( $args->{$name} ) eq "ARRAY" )
        {
            die "ARRAY";
        }
        elsif ( not ref $args->{$name} )
        {
            # warn "not a ref";
        }
        elsif ( blessed $args->{$name} )
        {
            # warn "Blessed: $args->{$name}";
            #confess "Wha'ppen?";
        }
    }
    $class->new( $args );
}

sub _camel_convert {
    local $_ = shift;
    s/_([a-z0-9])|\A([a-z])/uc($1||$2)/ge;
    $_;
}

1;

__DATA__

=pod

=head1 Name

Chargify::ObjectifiedData - ...

=head1 Synopsis

=head1 Description

=over 4

=item *

=back

=head1 License, Author, and Disclaimer of Warranty

See L<Chargify::API>.

=cut

