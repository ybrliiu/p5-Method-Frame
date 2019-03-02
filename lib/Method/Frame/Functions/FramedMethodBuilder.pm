package Method::Frame::Functions::FramedMethodBuilder;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();
use Method::Frame::Util;
use Method::Frame::Functions::FramedMethodBuilder::ListParameters;
use Method::Frame::Functions::FramedMethodBuilder::HashParameters;
use Method::Frame::Functions::FramedMethodBuilder::RequiredParameter;
use Method::Frame::Functions::FramedMethodBuilder::DefaultParameter;
use Method::Frame::Functions::FramedMethodBuilder::OptionalParameter;
use Method::Frame::Functions::FramedMethodBuilder::ReturnType;

use parent 'Method::Frame::Functions::Interfaces::FramedMethod';

sub new {
    my ($class, %args) = @_;
    for my $arg_name (qw[ name params return_type code ]) {
        Carp::croak "Missing argument '$arg_name'" unless $args{$arg_name};
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
        $params->isa('Method::Frame::Functions::FramedMethodBuilder::Parameters')
    ) {
        $params;
    }
    elsif ( ref $params eq 'ARRAY' ) {
        my @params_objects = map { $class->create_param($_) } @$params;
        Method::Frame::Functions::FramedMethodBuilder::ListParameters->new(\@params_objects);
    }
    elsif ( ref $params eq 'HASH' ) {
        my %params_objects = map { $_ => $class->create_param($params->{$_}) } keys %$params;
        Method::Frame::Functions::FramedMethodBuilder::HashParameters->new(\%params_objects);
    }
    else {
        Carp::confess 'Invalid parameters option passed.';
    }
}

sub create_param {
    my ($class, $param) = @_;
    if (
        Scalar::Util::blessed($param) && 
        $param->isa('Method::Frame::Functions::FramedMethodBuilder::Parameter')
    ) {
        $param;
    }
    elsif ( !(defined Method::Frame::Util::ensure_type_constraint_object($param) ) ) {
        Method::Frame::Functions::FramedMethodBuilder::RequiredParameter->new($param);
    }
    elsif ( ref $param eq 'HASH' ) {
        my $err = Method::Frame::Util::ensure_type_constraint_object($param->{isa});
        Carp::confess $err if defined $err;
        if ( exists $param->{default} ) {
            Method::Frame::Functions::FramedMethodBuilder::DefaultParameter
                ->new( $param->{isa}, $param->{default} );
        }
        elsif ( !!$param->{optional} ) {
            Method::Frame::Functions::FramedMethodBuilder::OptionalParameter->new($param->{isa});
        }
        else {
            Method::Frame::Functions::FramedMethodBuilder::RequiredParameter->new($param->{isa});
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
        $constraint->isa('Method::Frame::Functions::FramedMethodBuilder::ReturnType')
    ) {
        $constraint;
    }
    else {
        Method::Frame::Functions::FramedMethodBuilder::ReturnType->new($constraint);
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

