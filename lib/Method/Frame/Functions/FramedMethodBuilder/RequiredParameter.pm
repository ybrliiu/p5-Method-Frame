package Method::Frame::Functions::FramedMethodBuilder::RequiredParameter;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util;
use Method::Frame::Functions::ComparisonFrame::RequiredParameter;

use parent qw(
    Method::Frame::Functions::FramedMethodBuilder::Parameter
    Method::Frame::Functions::Interfaces::Frame::RequiredParameter
);

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

sub as_class_parameter {
    my $self = shift;
    Method::Frame::Functions::ComparisonFrame::RequiredParameter->new($self->constraint);
}

1;
