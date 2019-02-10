package Mule::Meta::Method::Argument;
use strict;
use warnings;
use utf8;
use Carp ();
use Scalar::Util ();

use Class::Accessor::Lite (
    ro => [qw( constraint default )],
);

sub new {
    my $class = shift;

    my $args = do {
        if ( @_ == 1 ) {
            +{ constraint => shift };
        }
        elsif ( @_ % 2 == 0 ) {
            my %args = @_;
            +{
                constraint => $args{isa},
                default    => $args{default},
            };
        }
        else {
            Carp::croak 'Invalid parameters passed.';
        }
    };

    my $self = bless $args, $class;

    my $constraint = $self->constraint;
    for my $required_method (qw[ check get_message ]) {
        Carp::croak "constraint object '$constraint' can not call $required_method"
            if !Scalar::Util::blessed($constraint) || !$constraint->can($required_method)
    }

    $self;
}

sub is_required {
    my $self = shift;
    defined $self->default;
}

sub validate {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($self, $maybe_arg) = @_;
    my $arg = do {
        if ( $self->is_required ) {
            if ( defined $maybe_arg ) {
                $maybe_arg;
            }
            else {
                Carp::croak 'Missing Argument.'
            }
        }
        else {
            defined $maybe_arg ? $maybe_arg : $self->default;
        }
    };
    $self->constraint->check($arg) ? $arg : Carp::croak 'Invalid type';
}

1;
