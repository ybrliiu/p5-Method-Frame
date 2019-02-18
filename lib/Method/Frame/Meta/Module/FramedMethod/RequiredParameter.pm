package Method::Frame::Meta::Module::FramedMethod::RequiredParameter;

use Method::Frame::Base;

use parent 'Method::Frame::Meta::Module::FramedMethod::Parameter';

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

sub compare {
    my ($self, $param) = @_;
    Carp::croak 'Argument must be MetaParameter object.'
        unless $param->isa('Method::Frame::Meta::Module::FramedMethod::Parameter');

    for my $maybe_err ( $self->compare_type($param), $self->compare_constraint($param) ) {
        return $maybe_err if defined $maybe_err;
    }
    undef;
}

1;
