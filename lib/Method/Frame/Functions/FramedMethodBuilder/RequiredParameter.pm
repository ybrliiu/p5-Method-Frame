package Method::Frame::Functions::FramedMethodBuilder::RequiredParameter;

use Method::Frame::Base;

use parent qw(
    Method::Frame::Functions::FramedMethodBuilder::Parameter
    Method::Frame::Functions::Interfaces::Frame::RequiredParameter
);

use Carp ();
use Method::Frame::Util;

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;

    my $err = Method::Frame::Util::ensure_type_constraint_object($constraint);
    Carp::croak $err if defined $err;

    bless +{ constraint => $constraint }, $class;
}

sub validate {
    my ($self, $argument) = @_;
    $self->constraint->check($argument)
        ? ( $argument, undef )
        : ( undef, $self->_failed_message($argument) );
}

1;
