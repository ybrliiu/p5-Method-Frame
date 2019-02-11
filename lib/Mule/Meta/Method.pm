package Mule::Meta::Method;
use strict;
use warnings;
use utf8;

use Scalar::Util ();
use Mule::Util;
use Mule::Meta::Method::ListParameters;
use Mule::Meta::Method::HashParameters;
use Mule::Meta::Method::RequiredParameter;
use Mule::Meta::Method::OptionalParameter;
use Mule::Meta::Method::ReturnType;

use Class::Accessor::Lite (
    ro => [qw( name params return_type code )],
);

sub new {
    my ($class, %args) = @_;
    for my $arg_name (qw[ name params return_type code ]) {
        Carp::croak "Missing argeter '$arg_name'" unless $args{$arg_name};
    }

    bless +{
        name        => $args{name},
        return_type => $class->create_return_type($args{return_type}),
        params      => $class->create_params($args{params}),
        code        => $args{code},
    }, $class;
}

sub create_params {
    my ($class, $params) = @_;
    if (
        Scalar::Util::blessed($params) &&
        $params->isa('Mule::Meta::Method::Parameters')
    ) {
        $params;
    }
    elsif ( ref $params eq 'ARRAY' ) {
        my @params_objects = map { $class->create_param($_) } @$params;
        Mule::Meta::Method::ListParameters->new(\@params_objects);
    }
    elsif ( ref $params eq 'HASH' ) {
        my %params_objects = map { $_ => $class->create_param($params->{$_}) } keys %$params;
        Mule::Meta::Method::HashParameters->new(\%params_objects);
    }
    else {
        Carp::confess 'Invalid parameters option passed.';
    }
}

sub create_param {
    my ($class, $param) = @_;
    if (
        Scalar::Util::blessed($param) && 
        $param->isa('Mule::Meta::Method::Parameter')
    ) {
        $param;
    }
    elsif ( !(defined Mule::Util::ensure_type_constraint_object($param) ) ) {
        Mule::Meta::Method::RequiredParameter->new($param);
    }
    elsif ( ref $param eq 'HASH' ) {
        my $err = Mule::Util::ensure_type_constraint_object($param->{isa});
        Carp::confess $err if defined $err;
        if ( exists $param->{optional} ) {
            Mule::Meta::Method::OptionalParameter->new($param->{isa});
        }
        elsif ( exists $param->{default} ) {
            Mule::Meta::Method::OptionalParameter->new($param->{isa}, $param->{default});
        }
        else {
            Mule::Meta::Method::RequiredParameter->new($param->{isa});
        }
    }
    else {
        Carp::confess 'Invalid parameter option passed.';
    }
}

sub create_return_type {
    my ($class, $constraint) = @_;
    if (
        Scalar::Util::blessed($constraint) &&
        $constraint->isa('Mule::Meta::Method::ReturnType')
    ) {
        $constraint;
    }
    else {
        Mule::Meta::Method::ReturnType->new($constraint);
    }
}

sub build {
    my $self = shift;
    sub {
        my $this = shift;

        my ($valid_args, $err) = $self->params->validate(@_);
        Carp::croak $err if defined $err;

        my $return_value = $self->code->($this, @$valid_args);

        if ( my $err = $self->return_type->validate($return_value) ) {
            Carp::croak qq{Method '@{[ $self->name ]}'s $err};
        }
        $return_value;
    };
}

1;