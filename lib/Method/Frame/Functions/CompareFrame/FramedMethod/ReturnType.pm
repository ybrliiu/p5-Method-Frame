package Method::Frame::Functions::CompareFrame::FramedMethod::ReturnType;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();
use Method::Frame::Util;

use Class::Accessor::Lite (
    ro => [qw( constraint )],
);

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;

    my $err = Method::Frame::Util::ensure_type_constraint_object($constraint);
    Carp::croak $err if defined $err;

    bless +{ constraint => $constraint }, $class;
}

sub _compare_constraint {
    my ($self, $return_type) = @_;

    $self->constraint->equals( $return_type->constraint )
        ? undef
        : q{constraint is different. }
            . "(@{[ $self->constraint->name ]} vs @{[ $return_type->constraint->name ]})";
}

sub compare {
    my ($self, $return_type) = @_;
    Carp::croak 'Argument must be ReturnType object.' unless $return_type->isa(__PACKAGE__);

    if ( my $err = $self->_compare_constraint($return_type) ) {
        [ $err ];
    }
    else {
        [];
    }
}

1;
