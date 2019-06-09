package Method::Frame::Domain::ComparisonFrame::Parameter;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();
use Role::Tiny;

requires 'new';

requires '_type';

sub _compare_type {
    my ($self, $param) = @_;

    $self->_type eq $param->_type
        ? undef
        : "type is different. (@{[ $self->_type ]} parameter vs @{[ $param->_type ]} parameter)";
}

sub _compare_constraint {
    my ($self, $param) = @_;

    $self->{constraint}->equals( $param->{constraint} )
        ? undef
        : q{constraint is different. }
            . "(@{[ $self->{constraint}->name ]} vs @{[ $param->{constraint}->name ]})";
}

sub compare {
    my ($self, $param) = @_;
    Carp::croak 'Argument must be MetaParameter object.' unless $param->DOES(__PACKAGE__);

    for my $maybe_err (
        $self->_compare_type($param),
        $self->_compare_constraint($param)
    ) {
        return $maybe_err if defined $maybe_err;
    }

    undef;
}

1;
