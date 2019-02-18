package Method::Frame::Meta::Module::FramedMethods;

use Method::Frame::Base;

use overload (
    '@{}'    => 'as_array_ref',
    fallback => 1,
);

use Carp ();
use Type::Utils ();
use Types::Standard ();

sub new {
    my ($class, $framed_methods) = @_;
    $framed_methods //= [];

    state $constraint = Types::Standard::ArrayRef(
        [ Type::Utils::class_type 'Method::Frame::Meta::Module::FramedMethod' ]
    );
    Carp::croak 'Argument value must be pass type constraint ArrayRef[FramedMethod]'
        unless $constraint->check($framed_methods);

    bless +{ map { $_->name => $_ } @$framed_methods }, $class;
}

sub exists :method {
    my ($self, $framed_method) = @_;
    Carp::croak 'Argument value must be FramedMethod object.'
        unless $framed_method->isa('Method::Frame::Meta::Module::FramedMethod');

    exists $self->{ $framed_method->name };
}

sub add {
    my ($self, $framed_method) = @_;
    Carp::croak 'Argument value must be FramedMethod object.'
        unless $framed_method->isa('Method::Frame::Meta::Module::FramedMethod');

    if ( $self->exists($framed_method) ) {
        "FramedMethod '@{[ $framed_method->name ]}' is already exists";
    }
    else {
        $self->{ $framed_method->name } = $framed_method;
        undef;
    }
}

sub maybe_get {
    my ($self, $abstract_framed_method) = @_;
    Carp::croak 'Argument value must be FramedMethod object.'
        unless $abstract_framed_method->isa('Method::Frame::Meta::Module::AbstractFramedMethod');

    $self->{ $abstract_framed_method->name };
}

sub as_array_ref {
    my $self = shift;
    [ values %$self ];
}

1;
