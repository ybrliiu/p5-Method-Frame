package Method::Frame::Domain::Role::RequiredFramedMethods;

use Method::Frame::Base;

use Carp ();
use Type::Utils ();
use Types::Standard ();
use Method::Frame::Util;

use Class::Accessor::Lite (
    new => 0,
    ro => [qw( _map )],
);

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $required_framed_methods) = @_;
    {
        state $constraint = do {
            my $class_name = 'Method::Frame::Domain::Role::RequiredFramedMethod';
            Types::Standard::ArrayRef([Type::Utils::class_type($class_name)]);
        };
        Carp::croak $constraint->get_message($required_framed_methods)
            unless $constraint->check($required_framed_methods);
    }

    bless +{ _map => +{ map { $_->name => $_ } @$required_framed_methods } }, $class;
}

sub _has {
    my ($self, $required_framed_method) = @_;
    Carp::croak 'Argument is not RequiredFramedMethod object.'
        unless $required_framed_method->isa('Method::Frame::Domain::Role::RequiredFramedMethod');

    exists $self->_map->{$required_framed_method->name};
}

sub add {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $required_framed_method) = @_;
    Carp::croak 'Argument is not RequiredFramedMethod object.'
        unless $required_framed_method->isa('Method::Frame::Domain::Role::RequiredFramedMethod');

    if ( $self->_has($required_framed_method) ) {
        "Required framed method '@{[ $required_framed_method->name ]}' is already exists.";
    }
    else {
        $self->_map->{$required_framed_method->name} = $required_framed_method;
        undef;
    }
}

sub apply {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $required_framed_methods) = @_;

    my @errors =
        grep { defined $_ }
        map { $self->add($_) }
        @{ $required_framed_methods->as_array_ref };
    \@errors;
}

sub are_implemented {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $framed_methods) = @_;
    Carp::croak 'Argument is not FrameMethods object'
        unless Method::Frame::Util::object_isa($framed_methods, 'Method::Frame::Domain::Role::FramedMethods');

    my @implemented_required_framed_methods =
        grep { $framed_methods->has($_) } @{ $self->as_array_ref };

    my $are_implemented = @implemented_required_framed_methods == $framed_methods->num;

    my @errors = map {
      my $required_framed_method = $_;
      my $framed_method = $framed_methods->maybe_get($required_framed_method);
      my $errors        = $required_framed_method->compare($framed_method);
      @$errors;
    } @implemented_required_framed_methods;

    ($are_implemented, \@errors);
}

sub as_array_ref {
    my $self = shift;
    [ values %{ $self->_map } ];
}

sub num {
    my $self = shift;
    scalar keys %{ $self->_map };
}

1;
