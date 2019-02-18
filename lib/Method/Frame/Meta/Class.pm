package Method::Frame::Meta::Class;

use Method::Frame::Base;
use Method::Frame::Meta::Class::FramedMethods;

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( framed_methods applied_role_names )],
);

use Carp ();
use Type::Utils ();
use Types::Standard ();

# override
sub new {
    my ($class, $framed_methods, $applied_role_names) = @_;
    $framed_methods     //= Method::Frame::Meta::Class::FramedMethods->new;
    $applied_role_names //= [];

    state $constraint = Types::Standard::ArrayRef(
        [ Type::Utils::class_type 'Method::Frame::Meta::Module::FramedMethod' ]
    );
    Carp::croak 'Argument value must be pass type constraint ArrayRef[FramedMethod]'
        unless $constraint->check($framed_methods);

    bless +{
        framed_methods     => $framed_methods,
        applied_role_names => $applied_role_names,
    }, $class;
}

# override
sub add_framed_method {
    my ($self, $framed_method) = @_;
    my $maybe_err = $self->framed_methods->add($framed_method);
    if ( defined $maybe_err ) {
        $maybe_err;
    }
    else {
        undef;
    }
}

# override
sub consume_role {
    my ($self, $role) = @_;

    push @{ $self->applied_role_names }, $role->name;

    for my $maybe_err (
        $role->apply_framed_methods( $self->framed_methods ),
        $role->apply_abstract_framed_methods_to_class( $self->framed_methods )
    ) {
        return $maybe_err if defined $maybe_err;
    }

    undef;
}

1;
