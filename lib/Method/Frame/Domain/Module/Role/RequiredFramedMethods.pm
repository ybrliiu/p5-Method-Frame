package Method::Frame::Domain::Module::Role::RequiredFramedMethods;

use Method::Frame::Base;

use Carp ();
use Type::Utils ();
use Types::Standard ();
use Method::Frame::Util qw( object_isa );

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $required_framed_methods) = @_;

    state $constraint = do {
        my $class_name = 'Method::Frame::Domain::Module::RequiredFramedMethod';
        Types::Standard::ArrayRef([Type::Utils::class_type($class_name)]);
    };
    Carp::croak $constraint->get_message($required_framed_methods)
        unless $constraint->check($required_framed_methods);

    bless +{ map => +{ map { $_->name => $_ } @$required_framed_methods } }, $class;
}

sub has {
    my ($self, $required_framed_method) = @_;
    Carp::croak 'Argument is not RequiredFramedMethod object.'
        unless $required_framed_method->isa('Method::Frame::Domain::Module::RequiredFramedMethod');

    exists $self->{map}->{ $required_framed_method->name };
}

sub add {
    my ($self, $required_framed_method) = @_;
    Carp::croak 'Argument is not RequiredFramedMethod object.'
        unless $required_framed_method->isa('Method::Frame::Domain::Module::RequiredFramedMethod');

    if ( $self->has($required_framed_method) ) {
        "Required framed method '@{[ $required_framed_method->name ]}' is already exists.";
    }
    else {
        $self->{map}->{$required_framed_method->name} = $required_framed_method;
        undef;
    }
}

1;
