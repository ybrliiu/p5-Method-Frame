package Method::Frame::Domain::Module::Class;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Domain::Module::Class::FramedMethods;
use Method::Frame::Domain::SymbolTableOperator;

use Class::Accessor::Lite (
    new => 0,
    ro => [qw( name framed_methods )]
);

sub new {
    my ($class, %args) = @_;
    Carp::croak "Missing argument 'name'" unless $args{name};

    bless +{
        name           => $args{name},
        framed_methods => Method::Frame::Domain::Module::Class::FramedMethods->new([]),
        symbol_table_operator =>
            Method::Frame::Domain::SymbolTableOperator->new($args{name}),
    }, $class;
}

sub add_framed_method {
    Carp::croak 'Too few argument.' if @_ < 2;
    my ($self, $framed_method_builder) = @_;
    Carp::croak 'Parameter does not FrameMethodBuilder object.'
        unless $framed_method_builder->isa('Method::Frame::Domain::FramedMethodBuilder');

    my $framed_method = $framed_method_builder->as_module_framed_method();
    if ( my $err = $self->{framed_methods}->add($framed_method) ) {
        $err;
    }
    else {
        my $maybe_err = $self->{symbol_table_operator}->add_subroutine(
            $framed_method_builder->name,
            $framed_method_builder->build
        );
        $maybe_err;
    }
}

1;
