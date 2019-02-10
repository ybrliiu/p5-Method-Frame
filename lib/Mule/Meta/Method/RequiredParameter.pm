package Mule::Meta::Method::RequiredParameter;
use 5.014004;
use strict;
use warnings;
use utf8;

use parent 'Mule::Meta::Method::Parameter';

use Carp ();
use Mule::Util;

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;

    my $err = Mule::Util::ensure_type_constraint_object($constraint);
    Carp::croak $err if defined $err;

    bless +{ constraint => $constraint }, $class;
}

sub validate {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($self, $argument) = @_;
    $self->constraint->check($argument)
        ? ( $argument, undef )
        : ( undef, qq{Parameter type is mismatch. (Parameter type is '@{[ $self->constraint ]}' but Argument value is '$argument'.)} );
}

1;

1;
