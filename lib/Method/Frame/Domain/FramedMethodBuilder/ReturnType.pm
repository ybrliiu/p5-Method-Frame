package Method::Frame::Domain::FramedMethodBuilder::ReturnType;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();
use Method::Frame::Util;
use Method::Frame::Domain::Module::Frame::ReturnType;

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;

    my $err = Method::Frame::Util::ensure_type_constraint_object($constraint);
    Carp::croak $err if defined $err;

    bless +{ constraint => $constraint }, $class;
}

sub validate {
    my ($self, $return_value) = @_;
    $self->{constraint}->check($return_value)
        ? undef
        : qq{Return type does not pass type constraint '$self->{constraint}' because : }
            . qq{Method code returns '$return_value')};
}

sub as_module_return_type {
    my $self = shift;
    Method::Frame::Domain::Module::Frame::ReturnType->new($self->{constraint});
}

1;
