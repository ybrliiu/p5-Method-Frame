package Method::Frame::Domain::Module::Role;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util qw( validate_argument_object_type );
use Method::Frame::Domain::Module::Role::FramedMethods;
use Method::Frame::Domain::Module::Role::RequiredFramedMethods;
use Method::Frame::Domain::Module::RequiredFramedMethod;

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( name )]
);

sub new {
    my ($class, %args) = @_;
    Carp::croak "Missing argument 'name'" unless $args{name};

    bless +{
        name           => $args{name},
        framed_methods => do {
            if ( exists $args{framed_methods} ) {
                validate_argument_object_type(
                    framed_methods => $args{framed_methods},
                    'Method::Frame::Domain::Module::Role::FramedMethods'
                );
                $args{framed_methods};
            }
            else {
                Method::Frame::Domain::Module::Role::FramedMethods->new([]);
            }
        },
        required_framed_methods => do {
            if ( exists $args{required_framed_methods} ) {
                validate_argument_object_type(
                    required_framed_methods => $args{required_framed_methods},
                    'Method::Frame::Domain::Module::Role::RequiredFramedMethods'
                );
                $args{required_framed_methods};
            }
            else {
                Method::Frame::Domain::Module::Role::RequiredFramedMethods->new([]);
            }
        },
        consumed_role_names => do {
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
    validate_argument_object_type(
        $framed_method,
        'Method::Frame::Domain::Module::Role::FramedMethod'
    );

    $self->framed_methods->add($framed_method);
}

sub add_required_framed_method {
    Carp::croak 'Too few argument.' if @_ < 2;
    my ($self, $required_framed_method) = @_;
    validate_argument_object_type(
        $required_framed_method,
        'Method::Frame::Domain::Module::RequiredFramedMethod'
    );

    $self->required_framed_methods->add($required_framed_method);
}

1;
