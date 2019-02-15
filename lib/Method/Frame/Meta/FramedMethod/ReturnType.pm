package Method::Frame::Meta::FramedMethod::ReturnType;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();
use Method::Frame::Util;

use Class::Accessor::Lite (
    ro => [qw( constraint )],
);

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;

    my $err = Method::Frame::Util::ensure_type_constraint_object($constraint);
    Carp::croak $err if defined $err;

    bless +{ constraint => $constraint }, $class;
}

sub validate {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($self, $return_value) = @_;
    my $constraint = $self->constraint;
    $constraint->check($return_value)
        ? undef
        : qq{Return type does not pass type constraint '$constraint' because : Method code returns '$return_value')};
}

1;
