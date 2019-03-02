package Method::Frame::Functions::Class;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Functions::Class::FramedMethod;
use Method::Frame::Functions::Class::FramedMethods;
use Method::Frame::Functions::SymbolTableOperator;

use Class::Accessor::Lite (
    new => 0,
    ro => [qw( name framed_methods symbol_table_operator )]
);

sub new {
    my ($class, %args) = @_;
    Carp::croak "Missing argument 'name'" unless $args{name};

    bless +{
        name           => $args{name},
        framed_methods => Method::Frame::Functions::Class::FramedMethods->new([]),
        symbol_table_operator =>
            Method::Frame::Functions::SymbolTableOperator->new($args{name}),
    }, $class;
}

sub add_framed_method {
    Carp::croak 'Too few argument.' if @_ < 2;
    my ($self, $framed_method_builder) = @_;
    Carp::croak 'Parameter does not FrameMethodBuilder object.'
        unless $framed_method_builder->isa('Method::Frame::Functions::FramedMethodBuilder');

    my $framed_method = Method::Frame::Functions::Class::FramedMethod->new($framed_method_builder);
    if ( my $err = $self->framed_methods->add($framed_method) ) {
        $err;
    }
    else {
        my $maybe_err = $self->symbol_table_operator->add_subroutine(
            $framed_method_builder->name,
            $framed_method_builder->build
        );
        $maybe_err;
    }
}

1;
