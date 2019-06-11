package Method::Frame::Domain::Module::Class;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util qw( validate_argument_object_type );
use Method::Frame::Domain::Module::Class::FramedMethods;
use Method::Frame::Domain::Module::SymbolTableOperator;

use Class::Accessor::Lite (
    new => 0,
    ro => [qw( name )]
);

sub new {
    my ($class, %args) = @_;
    Carp::croak "Missing argument 'name'" unless $args{name};

    my $symbol_table_operator = do {
        if ( exists $args{symbol_table_operator} ) {
            validate_argument_object_type(
                symbol_table_operator => $args{symbol_table_operator},
                'Method::Frame::Domain::Module::SymbolTableOperator'
            );
            $args{symbol_table_operator};
        }
        else {
            Method::Frame::Domain::Module::SymbolTableOperator->new($args{name});
        }
    };

    bless +{
        name           => $args{name},
        framed_methods => do {
            if ( exists $args{framed_methods} ) {
                validate_argument_object_type(
                    framed_methods => $args{framed_methods},
                    'Method::Frame::Domain::Module::Class::FramedMethods'
                );
                $args{framed_methods};
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
                $args{consumed_role_names};
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
    validate_argument_object_type($framed_method, 'Method::Frame::Domain::Module::FramedMethod');

    my $maybe_err = $self->{framed_methods}->add($framed_method);
}

1;
