package Method::Frame::Functions::FramedMethodBuilder::DefaultParameter;

use Method::Frame::Base;

use parent 'Method::Frame::Functions::FramedMethodBuilder::Parameter';

use Class::Accessor::Lite (
  ro => [qw( default )],
);

use Carp ();
use Scalar::Util ();
use Method::Frame::Util;

sub new {
    Carp::croak 'Too few arguments' if @_ < 3;
    my ($class, $constraint, $default) = @_;

    my $err = Method::Frame::Util::ensure_type_constraint_object($constraint);
    Carp::croak $err if defined $err;

    Carp::croak 'Default value does not pass type constraint.'
        unless $constraint->check($default);

    bless +{
        constraint => $constraint,
        default    => $default,
    }, $class;
}

sub validate {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($self, $maybe_argument) = @_;
    my $argument = $maybe_argument // $self->default;
    $self->constraint->check($argument)
        ? ( $argument, undef )
        : ( undef, qq{Parameter does not pass type constraint '@{[ $self->constraint ]}' because : Argument value is '$argument'.} );
}

1;
