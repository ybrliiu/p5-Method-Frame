package Method::Frame::Domain::ComparisonFrame::DefaultParameter;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();
use Data::Dumper ();
use Method::Frame::Util;
use Method::Frame::Domain::ComparisonFrame::ValuesEqualityChecker qw( value_equals );
use Class::Method::Modifiers qw( around );
use Role::Tiny::With qw( with );

with qw( Method::Frame::Domain::ComparisonFrame::Parameter );

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my $class = shift;
    my ($constraint, $default) = do {
        if ( @_ == 1 ) {
            if ( 
                Scalar::Util::blessed($_[0]) &&
                $_[0]->isa('Method::Frame::Domain::Module::Frame::DefaultParameter')
            ) {
                ( $_[0]->constraint, $_[0]->default );
            }
            else {
                Carp::croak 'Argument is not DefaultParameter object.';
            }
        }
        else {
            @_;
        }
    };

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

    value_equals($self->{default}, $param->{default})
        ? undef
        : $self->_different_default_message($self->{default}, $param->{default});
}

around compare => sub {
    my ($orig, $self, $param) = @_;
    Carp::croak 'Argument must be MetaParameter object.'
        unless $param->DOES('Method::Frame::Domain::ComparisonFrame::Parameter');

    for my $maybe_err (
        $self->$orig($param),
        $self->_compare_default($param)
    ) {
        return $maybe_err if defined $maybe_err;
    }

    undef;
};

1;
