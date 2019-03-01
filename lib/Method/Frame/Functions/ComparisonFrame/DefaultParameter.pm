package Method::Frame::Functions::ComparisonFrame::DefaultParameter;

use Method::Frame::Base;

use parent qw(
    Method::Frame::Functions::ComparisonFrame::Parameter
    Method::Frame::Functions::Interfaces::Frame::DefaultParameter
);

use Carp ();
use Scalar::Util ();
use Data::Dumper ();
use Method::Frame::Util;
use Method::Frame::Functions::ComparisonFrame::ValuesEqualityChecker qw( value_equals );

# override
sub new {
    Carp::croak 'Too few arguments' if @_ < 3;
    my ($class, $constraint, $default) = @_;

    my $err = Method::Frame::Util::ensure_type_constraint_object($constraint);
    Carp::croak $err if defined $err;

    Carp::croak 'Default value does not pass type constraint.'
        unless $constraint->check($default);

    if ( Scalar::Util::blessed($default) ) {
        Carp::croak q{Default value object can not call 'equals' method.}
            unless $default->can('equals');
    }

    bless +{
        constraint => $constraint,
        default    => $default,
    }, $class;
}

# override
sub _type { 'default' }

sub _dumper {
    my $default = shift;
    my $dumper = Data::Dumper->new([$default]);
    $dumper->Terse(1)->Indent(0);
    $dumper->Dump($default);
}

sub _different_default_message {
    my ($class, $self_default, $param_default) = @_;

    "default value is different. (@{[ _dumper($self_default) ]} vs @{[ _dumper($param_default) ]})";
}

sub _compare_default {
    my ($self, $param) = @_;
    Carp::croak 'Argument must be MetaDefaultParameter object.' unless $param->isa(ref $self);

    # assert _compare_type
    # assert _compare_constraint

    value_equals($self->default, $param->default)
        ? undef
        : $self->_different_default_message($self->default, $param->default);
}

# override
sub compare {
    my ($self, $param) = @_;
    Carp::croak 'Argument must be MetaParameter object.'
        unless $param->isa('Method::Frame::Functions::ComparisonFrame::Parameter');

    for my $maybe_err (
        $self->SUPER::compare($param),
        $self->_compare_default($param)
    ) {
        return $maybe_err if defined $maybe_err;
    }

    undef;
}

1;
