package Method::Frame::Domain::FramedMethodBuilder::DefaultParameter;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();
use Try::Tiny;
use Method::Frame::Util;
use Role::Tiny::With qw( with );

with 'Method::Frame::Domain::FramedMethodBuilder::Parameter';

sub new {
    Carp::croak 'Too few arguments' if @_ < 3;
    my ($class, $constraint, $default) = @_;

    {
        my $err = Method::Frame::Util::ensure_type_constraint_object($constraint);
        Carp::croak $err if defined $err;
    }

    unless ( $class->_can_use_for_default($default) ) {
        Carp::croak "Invalid default value '$default' "
            . "is not a coderef or code-convertible object or a non-ref.";
    }

    {
        my $err = $class->_validate_default_type($constraint, $default);
        Carp::croak $err if defined $err;
    }

    bless +{
        constraint => $constraint,
        default    => $default,
    }, $class;
}

sub default :method { $_[0]->{default} }

sub _can_use_for_default {
    my ($class, $default) = @_;
    if ( !ref $default ) {
        1;
    }
    elsif ( Scalar::Util::blessed($default) ) {
      try { &$default || 1 } catch { 0 };
    }
    elsif ( ref $default eq 'CODE' ) {
        1;
    }
    else {
        0;
    }
}

sub _validate_default_type {
    my ($class, $constraint, $default) = @_;

    my $err_mes = 'Default value does not pass type constraint.';

    # Default value is literal
    if ( !ref $default ) {
        $constraint->check($default) ? undef : $err_mes;
    }
    # Default value is coderef or code-convertible object.
    else {
        my $maybe_default = try { $default->() } catch { undef };
        # デフォルト引数用のcoderefが他の引数無しでも呼び出せるなら, その関数の返り値をチェック
        if ( defined $maybe_default ) {
            $constraint->check($maybe_default) ? undef : $err_mes;
        }
        else {
            undef;
        }
    }
}

sub validate {
    my ($self, $maybe_argument, @other_arguments) = @_;
    my $argument = $maybe_argument
        // (ref $self->{default} ? $self->{default}->(@other_arguments) : $self->{default});
    $self->{constraint}->check($argument)
        ? ( $argument, undef )
        : ( undef, $self->_failed_message($argument) );
}

1;
