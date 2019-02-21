package Method::Frame::Functions::CompareFrame::FramedMethod::RequiredParameter;

use Method::Frame::Base;

use parent 'Method::Frame::Functions::CompareFrame::FramedMethod::Parameter';

use Carp ();
use Method::Frame::Util;

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;

    my $err = Method::Frame::Util::ensure_type_constraint_object($constraint);
    Carp::croak $err if defined $err;

    bless +{ constraint => $constraint }, $class;
}

sub _type { 'required' }

sub compare {
    my ($self, $param) = @_;
    Carp::croak 'Argument must be MetaParameter object.'
        unless $param->isa('Method::Frame::Functions::CompareFrame::FramedMethod::Parameter');

    for my $maybe_err (
        $self->_compare_type($param),
        $self->_compare_constraint($param)
    ) {
        return $maybe_err if defined $maybe_err;
    }

    undef;
}

1;
