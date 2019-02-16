package Method::Frame::Meta::Module::FramedMethod;

use Method::Frame::Base;

use Scalar::Util ();
use Method::Frame::Util;
use Method::Frame::Meta::Module::FramedMethod::ListParameters;
use Method::Frame::Meta::Module::FramedMethod::HashParameters;
use Method::Frame::Meta::Module::FramedMethod::RequiredParameter;
use Method::Frame::Meta::Module::FramedMethod::OptionalParameter;
use Method::Frame::Meta::Module::FramedMethod::ReturnType;

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
        $params->isa('Method::Frame::Meta::Module::FramedMethod::Parameters')
    ) {
        $params;
    }
    elsif ( ref $params eq 'ARRAY' ) {
        my @params_objects = map { $class->create_param($_) } @$params;
        Method::Frame::Meta::Module::FramedMethod::ListParameters->new(\@params_objects);
    }
    elsif ( ref $params eq 'HASH' ) {
        my %params_objects = map { $_ => $class->create_param($params->{$_}) } keys %$params;
        Method::Frame::Meta::Module::FramedMethod::HashParameters->new(\%params_objects);
    }
    else {
        Carp::confess 'Invalid parameters option passed.';
    }
}

sub create_param {
    my ($class, $param) = @_;
    if (
        Scalar::Util::blessed($param) && 
        $param->isa('Method::Frame::Meta::Module::FramedMethod::Parameter')
    ) {
        $param;
    }
    elsif ( !(defined Method::Frame::Util::ensure_type_constraint_object($param) ) ) {
        Method::Frame::Meta::Module::FramedMethod::RequiredParameter->new($param);
    }
    elsif ( ref $param eq 'HASH' ) {
        my $err = Method::Frame::Util::ensure_type_constraint_object($param->{isa});
        Carp::confess $err if defined $err;
        if ( exists $param->{optional} ) {
            Method::Frame::Meta::Module::FramedMethod::OptionalParameter->new($param->{isa});
        }
        elsif ( exists $param->{default} ) {
            Method::Frame::Meta::Module::FramedMethod::OptionalParameter->new($param->{isa}, $param->{default});
        }
        else {
            Method::Frame::Meta::Module::FramedMethod::RequiredParameter->new($param->{isa});
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
        $constraint->isa('Method::Frame::Meta::Module::FramedMethod::ReturnType')
    ) {
        $constraint;
    }
    else {
        Method::Frame::Meta::Module::FramedMethod::ReturnType->new($constraint);
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
