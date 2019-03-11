package Method::Frame::Domain::FramedMethodBuilder::DefaultParameter;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();
use Method::Frame::Util qw( object_isa );
use Role::Tiny::With qw( with );

with 'Method::Frame::Domain::FramedMethodBuilder::Parameter';

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
    my ($self, $maybe_argument) = @_;
    my $argument = $maybe_argument // $self->{default};
    $self->{constraint}->check($argument)
        ? ( $argument, undef )
        : ( undef, $self->_failed_message($argument) );
}

1;
