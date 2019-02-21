package Method::Frame::Functions::FramedMethodBuilder::RequiredParameter;

use Method::Frame::Base;

use parent 'Method::Frame::Functions::FramedMethodBuilder::Parameter';

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
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($self, $argument) = @_;
    $self->constraint->check($argument)
        ? ( $argument, undef )
        : ( undef, qq{Parameter does not pass type constraint '@{[ $self->constraint ]}' because : Argument value is '$argument'.} );
}

1;
