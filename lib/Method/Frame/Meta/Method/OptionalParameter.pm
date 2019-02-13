package Method::Frame::Meta::Method::OptionalParameter;

use Method::Frame::Base;

use parent 'Method::Frame::Meta::Method::Parameter';

use Class::Accessor::Lite (
  ro => [qw( maybe_default )],
);

use Carp ();
use Method::Frame::Util;

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint, $maybe_default) = @_;

    my $err = Method::Frame::Util::ensure_type_constraint_object($constraint);
    Carp::croak $err if defined $err;

    bless +{
        constraint    => $constraint,
        maybe_default => $maybe_default,
    }, $class;
}

sub validate {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($self, $maybe_argument) = @_;
    my $argument = $maybe_argument // $self->maybe_default;
    $self->constraint->check($argument)
        ? ( $argument, undef )
        : ( undef, qq{Parameter does not pass type constraint '@{[ $self->constraint ]}' because : Argument value is '$argument'.} );
}

1;
