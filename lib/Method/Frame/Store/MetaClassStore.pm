package Method::Frame::Store::MetaClassStore;

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
    my ($class, $meta_class) = @_;
    Carp::croak 'Argument does not Method::Frame::Functions::Class object.'
        unless $meta_class->isa('Method::Frame::Functions::Class');

    $STORE{ $meta_class->name } = $meta_class;
}

1;
