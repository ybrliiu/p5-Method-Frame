package Method::Frame::Functions::CompareFrame::FramedMethod::Parameter;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( constraint )],
);

sub new { Carp::croak 'This is abstract method.' }

sub _type { Carp::croak 'This is abstract method.' }

sub _compare_type {
    my ($self, $param) = @_;
    Carp::croak 'Argument must be MetaParameter object.' unless $param->isa(__PACKAGE__);

    $self->_type eq $param->_type
        ? undef
        : "MetaParameter type is different. (@{[ $self->_type ]} vs @{[ $param->_type ]})";
}

sub _compare_constraint {
    my ($self, $param) = @_;
    Carp::croak 'Argument must be MetaParameter object.' unless $param->isa(__PACKAGE__);

    $self->constraint->equals( $param->constraint )
        ? undef
        : 'MetaParameter constraint is different. '
            . "(@{[ $self->constraint->name ]} vs @{[ $param->constraint->name ]})";
}

sub compare {
    my ($self, $param) = @_;
    Carp::croak 'Argument must be MetaParameter object.'
        unless $param->isa('Method::Frame::Functions::CompareFrame::FramedMethod::Parameter');

    for my $maybe_err (
        $self->_compare_type($param),
        $self->_compare_constraint($param)
    ) {
        return $maybe_err if defined $maybe_err;
    }

    undef;
}

1;
