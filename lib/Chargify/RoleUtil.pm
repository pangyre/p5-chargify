package Chargify::RoleUtil;
use Mouse::Role;
use JSON;

sub as_json {
    my $self = shift;
    my $class = blessed($self);
    ( my $key = lc $class ) =~ s/\AChargify:://i;

    my %data;
    for my $attr ( $self->meta->get_all_attributes ) {
        my $method = $attr->name;
        $data{$method} = $self->$method;
    }
    encode_json({ $key => \%data });
}

1;

__END__
