package Method::Frame::Meta::Module::FramedMethod::Parameter;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( constraint )],
);

sub new { Carp::croak 'This is abstract method.' }

sub validate { Carp::croak 'This is abstract method.' }

sub type { Carp::croak 'This is abstract method.' }

sub compare { Carp::croak 'This is abstract method.' }

sub compare_type {
    my ($self, $param) = @_;
    Carp::croak 'Argument must be MetaParameter object.' unless $param->isa(__PACKAGE__);

    $self->type eq $param->type
        ? undef
        : "MetaParameter type is different. (@{[ $self->type ]} vs @{[ $param->type ]})";
}

sub compare_constraint {
    my ($self, $param) = @_;
    Carp::croak 'Argument must be MetaParameter object.' unless $param->isa(__PACKAGE__);

    $self->constraint->equals( $param->constraint )
        ? undef
        : 'MetaParameter constraint is different. '
            . "(@{[ $self->constraint->name ]} vs @{[ $param->constraint->name ]})";
}

1;
