package Mule::Meta::Method;
use strict;
use warnings;
use utf8;

use Scalar::Util ();
use Mule::Meta::Method::RequiredParameter;
use Mule::Meta::Method::ListParameters;
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
    my @params_objects = map { Mule::Meta::Method::RequiredParameter->new($_) } @$params;
    Mule::Meta::Method::ListParameters->new(\@params_objects);
}

sub create_return_type {
    my ($class, $constraint) = @_;
    Mule::Meta::Method::ReturnType->new($constraint);
}

sub build {
    my $self = shift;
    sub {
        my $this = shift;

        my ($valid_args, $err) = $self->params->validate(@_);
        if ( defined $err ) {
            Carp::croak $err;
        }

        my $return_value = $self->code->($this, @$valid_args);

        if ( my $err = $self->return_type->validate($return_value) ) {
            Carp::croak 'Method ' . $self->name . ' ' . $err;
        }
        $return_value;
    };
}

1;
