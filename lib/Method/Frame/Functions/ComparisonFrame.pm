package Method::Frame::Functions::ComparisonFrame;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();
use Method::Frame::Util;
use Method::Frame::Functions::ComparisonFrame::ListParameters;
use Method::Frame::Functions::ComparisonFrame::HashParameters;
use Method::Frame::Functions::ComparisonFrame::RequiredParameter;
use Method::Frame::Functions::ComparisonFrame::DefaultParameter;
use Method::Frame::Functions::ComparisonFrame::OptionalParameter;
use Method::Frame::Functions::ComparisonFrame::ReturnType;

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( name params return_type )],
);

sub new {
    my ($class, %args) = @_;
    for my $arg_name (qw[ name params return_type ]) {
        Carp::croak "Missing argument '$arg_name'" unless $args{$arg_name};
    }

    bless +{
        name        => $args{name},
        return_type => $class->create_return_type($args{return_type}),
        params      => $class->create_params($args{params}),
    }, $class;
}

sub create_params {
    my ($class, $params) = @_;
    if (
        Scalar::Util::blessed($params) &&
        $params->isa('Method::Frame::Functions::ComparisonFrame::Parameters')
    ) {
        $params;
    }
    elsif ( ref $params eq 'ARRAY' ) {
        my @params_objects = map { $class->create_param($_) } @$params;
        Method::Frame::Functions::ComparisonFrame::ListParameters->new(\@params_objects);
    }
    elsif ( ref $params eq 'HASH' ) {
        my %params_objects = map { $_ => $class->create_param($params->{$_}) } keys %$params;
        Method::Frame::Functions::ComparisonFrame::HashParameters->new(\%params_objects);
    }
    else {
        Carp::confess 'Invalid parameters option passed.';
    }
}

sub create_param {
    my ($class, $param) = @_;
    if (
        Scalar::Util::blessed($param) && 
        $param->isa('Method::Frame::Functions::ComparisonFrame::Parameter')
    ) {
        $param;
    }
    elsif ( !(defined Method::Frame::Util::ensure_type_constraint_object($param) ) ) {
        Method::Frame::Functions::ComparisonFrame::RequiredParameter->new($param);
    }
    elsif ( ref $param eq 'HASH' ) {
        my $err = Method::Frame::Util::ensure_type_constraint_object($param->{isa});
        Carp::confess $err if defined $err;
        if ( exists $param->{default} ) {
            Method::Frame::Functions::ComparisonFrame::DefaultParameter
                ->new( $param->{isa}, $param->{default} );
        }
        elsif ( !!$param->{optional} ) {
            Method::Frame::Functions::ComparisonFrame::OptionalParameter->new($param->{isa});
        }
        else {
            Method::Frame::Functions::ComparisonFrame::RequiredParameter->new($param->{isa});
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
        $constraint->isa('Method::Frame::Functions::ComparisonFrame::ReturnType')
    ) {
        $constraint;
    }
    else {
        Method::Frame::Functions::ComparisonFrame::ReturnType->new($constraint);
    }
}

sub compare {
    my ($self, $frame) = @_;

    if ( $self->name ne $frame->name ) {
        [ "Frame name is different. (@{[ $self->name ]} vs @{[ $frame->name ]})" ];
    }
    else {
        [
            @{ $self->params->compare( $frame->params ) },
            @{ $self->return_type->compare( $frame->return_type ) },
        ]
    }
}

1;