package Method::Frame::Domain::Module::Class;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util qw( object_isa );
use Method::Frame::Domain::Module::Class::FramedMethods;
use Method::Frame::Domain::Module::SymbolTableOperator;

use Class::Accessor::Lite (
    new => 0,
    ro => [qw( name framed_methods )]
);

sub new {
    my ($class, %args) = @_;
    Carp::croak "Missing argument 'name'" unless $args{name};

    my $symbol_table_operator = do {
        if ( exists $args{symbol_table_operator} ) {
            my $is_symbol_table_operator = object_isa(
                $args{symbol_table_operator},
                'Method::Frame::Domain::Module::SymbolTableOperator',
            );
            Carp::croak "Argument 'symbol_table_operator' is not SymbolTableOperator object"
                unless $is_symbol_table_operator;
        }
        else {
            Method::Frame::Domain::Module::SymbolTableOperator->new($args{name});
        }
    };

    bless +{
        name           => $args{name},
        framed_methods => do {
            if ( exists $args{framed_methods} ) {
                my $is_framed_methods = object_isa(
                    $args{framed_methods},
                    'Method::Frame::Domain::Module::Class::FramedMethods'
                );
                Carp::croak "Argument 'framed_methods' is not FrameMethods object"
                    unless $is_framed_methods;
            }
            else {
                Method::Frame::Domain::Module::Class::FramedMethods->new([], $symbol_table_operator);
            }
        },
        symbol_table_operator => $symbol_table_operator,
        consumed_role_names   => do {
            if ( exists $args{consumed_role_names} ) {
                Carp::croak "Argument 'consumed_role_names' is not ArrayRef"
                    unless ref $args{consumed_role_names} eq 'ARRAY';
            }
            else {
                [];
            }
        },
    }, $class;
}

sub add_framed_method {
    Carp::croak 'Too few argument.' if @_ < 2;
    my ($self, $framed_method) = @_;
    Carp::croak 'Parameter is not FramedMethod object.'
        unless object_isa($framed_method, 'Method::Frame::Domain::Module::FramedMethod');

    my $maybe_err = $self->{framed_methods}->add($framed_method);
}

1;
