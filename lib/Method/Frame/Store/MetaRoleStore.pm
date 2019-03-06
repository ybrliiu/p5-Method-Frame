package Method::Frame::Store::MetaRoleStore;

use Method::Frame::Base;

use Carp ();

my %STORE;

sub maybe_get {
    Carp::croak 'Too few argument.' if @_ < 2;
    my ($class, $name) = @_;
    $STORE{$name};
}

sub store {
    Carp::croak 'Too few argument.' if @_ < 2;
    my ($class, $meta_role) = @_;
    Carp::croak 'Argument does not Method::Frame::Functions::Role object.'
        unless $meta_role->isa('Method::Frame::Functions::Role');

    $STORE{ $meta_role->name } = $meta_role
}

1;
