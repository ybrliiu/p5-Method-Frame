package Method::Frame::Domain::Module::Role::FramedMethods;

use Method::Frame::Base;

use Carp ();
use Type::Utils ();
use Types::Standard ();
use Method::Frame::Util qw( object_isa );

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $framed_methods) = @_;

    state $constraint = do {
        my $class_name = 'Method::Frame::Domain::Module::FramedMethod';
        Types::Standard::ArrayRef([Type::Utils::class_type($class_name)]);
    };
    Carp::croak $constraint->get_message($framed_methods)
        unless $constraint->check($framed_methods);

    bless +{ map => +{ map { $_->name => $_ } @$framed_methods } }, $class;
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
        undef;
    }
}

sub as_array_ref {
    my $self = shift;
    [ keys %{ $self->{map} } ];
}

1;
