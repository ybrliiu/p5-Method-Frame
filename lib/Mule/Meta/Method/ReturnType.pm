package Mule::Meta::Method::ReturnType;
use strict;
use warnings;
use utf8;
use Carp ();
use Scalar::Util ();

use Class::Accessor::Lite (
    ro => [qw( constraint )],
);

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;

    for my $required_method (qw[ check get_message ]) {
        Carp::croak "constraint object '$constraint' can not call $required_method"
            if !Scalar::Util::blessed($constraint) || !$constraint->can($required_method)
    }

    bless +{ constraint => $constraint }, $class;
}

sub validate {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($self, $return_value) = @_;
    my $constraint = $self->constraint;
    $constraint->check($return_value)
        ? undef
        : qq{Return type is mismatch. (Constraint is '$constraint' but method code returns '$return_value')};
}

1;
