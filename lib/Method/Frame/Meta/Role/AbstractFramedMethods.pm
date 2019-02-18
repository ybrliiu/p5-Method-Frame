package Method::Frame::Meta::Role::AbstractFramedMethods;

use Method::Frame::Base;

use overload (
    '@{}'    => 'as_array_ref',
    fallback => 1,
);

use Carp ();
use Type::Utils ();
use Types::Standard ();

sub new {
    my ($class, $abstract_framed_methods) = @_;
    $abstract_framed_methods //= [];

    state $constraint = Types::Standard::ArrayRef(
        [ Type::Utils::class_type 'Method::Frame::Meta::Module::AbstractFramedMethod' ]
    );
    Carp::croak 'Argument value must be pass type constraint ArrayRef[FramedMethod]'
        unless $constraint->check($abstract_framed_methods);

    bless +{ map { $_->name => $_ } @$abstract_framed_methods }, $class;
}

sub add {
    my ($self, $abstract_framed_method) = @_;
    Carp::croak 'Argument value must be AbstractFramedMethod object.'
        unless $abstract_framed_method->isa('Method::Frame::Meta::Module::AbstractFramedMethod');

    if ( exists $self->{ $abstract_framed_method->name } ) {
        "Abstract framed method '@{[ $abstract_framed_method->name ]}' already exists";
    }
    else {
        $self->{ $abstract_framed_method->name } = $abstract_framed_method;
        undef;
    }
}

sub check {
    my ($self, $framed_methods) = @_;
    Carp::croak 'Argument value must be FramedMethod object.'
        unless $framed_methods->isa('Method::Frame::Meta::Module::FramedMethods');

    my @errors = map {
        my $abstract_framed_method = $_;
        my $maybe_framed_method = $framed_methods->maybe_get($abstract_framed_method);
        if ( defined $maybe_framed_method ) {
            my $framed_method = $maybe_framed_method;
            $abstract_framed_method->validate_frame($framed_method);
        }
        else {
            [ undef, "Framed method '@{[ $abstract_framed_method->name ]}' does not exists" ];
        }
    } @{ $self->as_array_ref };

    \@errors;
}

sub as_array_ref {
    my $self = shift;
    [ values %$self ];
}

1;

