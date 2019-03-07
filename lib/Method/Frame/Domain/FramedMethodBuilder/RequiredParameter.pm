package Method::Frame::Domain::FramedMethodBuilder::RequiredParameter;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util;
use Method::Frame::Domain::ComparisonFrame::RequiredParameter;

use parent qw(Method::Frame::Domain::FramedMethodBuilder::Parameter Method::Frame::Domain::Module::Frame::RequiredParameter);

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
    Method::Frame::Domain::ComparisonFrame::RequiredParameter->new($self->constraint);
}

1;
