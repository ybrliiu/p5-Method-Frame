package Method::Frame::Domain::ComparisonFrame::ReturnType;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();
use Method::Frame::Util;

use parent 'Method::Frame::Domain::Interfaces::Frame::ReturnType';

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my $class = shift;
    my $constraint = do {
        if ( 
            Scalar::Util::blessed($_[0]) &&
            $_[0]->isa('Method::Frame::Domain::Interfaces::Frame::ReturnType')
        ) {
            $_[0]->constraint;
        }
        else {
            $_[0];
        }
    };

    my $err = Method::Frame::Util::ensure_type_constraint_object($constraint);
    Carp::croak $err if defined $err;

    bless +{ constraint => $constraint }, $class;
}

sub _compare_constraint {
    my ($self, $return_type) = @_;

    $self->constraint->equals( $return_type->constraint )
        ? undef
        : q{ReturnType constraint is different. }
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
