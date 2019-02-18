package Method::Frame::Meta::Module::FramedMethod::OptionalParameter;

use Method::Frame::Base;

use parent 'Method::Frame::Meta::Module::FramedMethod::Parameter';

use Class::Accessor::Lite (
  ro => [qw( maybe_default )],
);

use Carp ();
use Scalar::Util ();
use Method::Frame::Util;

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint, $maybe_default) = @_;

    my $err = Method::Frame::Util::ensure_type_constraint_object($constraint);
    Carp::croak $err if defined $err;

    Carp::croak 'Default value does not pass type constraint.'
        if !defined $maybe_default || $constraint->check($maybe_default);

    bless +{
        constraint    => $constraint,
        maybe_default => $maybe_default,
    }, $class;
}

sub validate {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($self, $maybe_argument) = @_;
    my $argument = $maybe_argument // $self->maybe_default;
    $self->constraint->check($argument)
        ? ( $argument, undef )
        : ( undef, qq{Parameter does not pass type constraint '@{[ $self->constraint ]}' because : Argument value is '$argument'.} );
}

sub compare_maybe_default {
    my ($self, $param) = @_;
    Carp::croak 'Argument must be MetaOptionalParameter object.' unless $param->isa(__PACKAGE__);

    if ( defined $self->maybe_default && defined $param->maybe_default ) {
        if ( Scalar::Util::looks_like_number($self->maybe_default) ) {
            $self->maybe_default == $param->maybe_default;
        }
        elsif ( Scalar::Util::blessed($self->maybe_default) ) {
            if ( $self->maybe_default->can('equals') ) {
                $self->maybe_default->equals( $param->maybe_default )
                    ? undef
                    : '';
            }
            else {
                "Can't compare @{[ $self->maybe_default ]} because can't call equals method."
            }
        }
        elsif ( ref $self->maybe_default eq 'ARRAY' ) {
        }
        elsif ( ref $self->maybe_default eq 'HASH' ) {
        }
        else {
            # maybe comes string value 
            $self->maybe_default eq $param->maybe_default;
        }
    }
    else {
        if ( defined $self->maybe_default && !defined $param->maybe_default ) {
            'MetaParameter default value is different.'
                . "('@{[ $self->maybe_default ]}' vs undefined value)";
        }
        elsif ( !defined $self->maybe_default && defined $param->maybe_default ) {
            'MetaParameter default value is different.'
                . "(undefined value vs '@{[ $param->maybe_default ]}')";
        }
        # Both MetaParameter's default values are undefined.
        else {
            undef;
        }
    }
}

sub compare {
    my ($self, $param) = @_;
    Carp::croak 'Argument must be MetaParameter object.'
        unless $param->isa('Method::Frame::Meta::Module::FramedMethod::Parameter');

    for my $maybe_err (
        $self->compare_type($param),
        $self->compare_constraint($param),
        $self->compare_maybe_default($param)
    ) {
        return $maybe_err if defined $maybe_err;
    }
    undef;
}

1;
