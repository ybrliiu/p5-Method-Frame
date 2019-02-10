package Mule::Meta::Method;
use strict;
use warnings;
use utf8;

use Scalar::Util ();
use Mule::Meta::Method::Argument;
use Mule::Meta::Method::ListArguments;
use Mule::Meta::Method::ReturnType;

use Class::Accessor::Lite (
    ro => [qw( name arguments return_type code )],
);

sub new {
    my ($class, %args) = @_;
    for my $param_name (qw[ name arguments return_type code ]) {
        Carp::croak "Missing parameter '$param_name'" unless $args{$param_name};
    }

    bless +{
        name        => $args{name},
        return_type => $class->create_return_type($args{return_type}),
        arguments   => $class->create_arguments($args{arguments}),
        code        => $args{code},
    }, $class;
}

sub create_arguments {
    my ($class, $args) = @_;
    my @arguments = map { Mule::Meta::Method::Argument->new($_) } @$args;
    Mule::Meta::Method::ListArguments->new(\@arguments);
}

sub create_return_type {
    my ($class, $constraint) = @_;
    Mule::Meta::Method::ReturnType->new($constraint);
}

sub build {
    my $self = shift;
    sub {
        my $this = shift;

        my ($valid_args, $err) = $self->arguments->validate(@_);
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
