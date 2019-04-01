package Method::Frame::Domain::Module::Class::FramedMethods;

use Method::Frame::Base;

use Carp ();
use Type::Utils ();
use Types::Standard ();
use Method::Frame::Util qw( object_isa );

sub new {
    Carp::croak 'Too few arguments' if @_ < 3;
    my ($class, $framed_methods, $symbol_table_operator) = @_;

    state $constraint = do {
        my $class_name = 'Method::Frame::Domain::Module::FramedMethod';
        Types::Standard::ArrayRef([Type::Utils::class_type($class_name)]);
    };
    Carp::croak $constraint->get_message($framed_methods)
        unless $constraint->check($framed_methods);

    my $is_symbol_table_operator = object_isa(
        $symbol_table_operator,
        'Method::Frame::Domain::Module::SymbolTableOperator',
    );
    Carp::croak "Argument 'symbol_table_operator' is not SymbolTableOperator object"
        unless $is_symbol_table_operator;

    bless +{
        map                   => +{ map { $_->name => $_ } @$framed_methods },
        symbol_table_operator => $symbol_table_operator,
    }, $class;
}

sub has {
    my ($self, $framed_method) = @_;
    Carp::croak 'Argument is not FrameMethod object.'
        unless $framed_method->isa('Method::Frame::Domain::Module::FramedMethod');

    exists $self->{map}->{ $framed_method->name };
}

sub add {
    my ($self, $framed_method) = @_;
    Carp::croak 'Argument is not FrameMethod object.'
        unless $framed_method->isa('Method::Frame::Domain::Module::FramedMethod');

    if ( $self->has($framed_method) ) {
        "Framed method '@{[ $framed_method->name ]}' is already exists.";
    }
    else {
        $self->{map}->{ $framed_method->name } = $framed_method;
        my $builder = $framed_method->as_framed_method_builder();
        $self->{symbol_table_operator}->add_subroutine($framed_method->name, $builder->build());
        undef;
    }
}

sub remove {
    my ($self, $framed_method) = @_;
    Carp::croak 'Argument is not FrameMethod object.'
        unless $framed_method->isa('Method::Frame::Domain::Module::FramedMethod');

    if ( $self->has($framed_method) ) {
        delete $self->{map}->{ $framed_method->name };
        $self->{symbol_table_operator}->remove_subroutine($framed_method->name);
        undef;
    }
    else {
        "Framed method '@{[ $framed_method->name ]}' does not exists.";
    }
}

1;

__END__
