package Method::Frame::Domain::Module::Role;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util qw( object_isa );
use Method::Frame::Domain::Module::Role::FramedMethods;
use Method::Frame::Domain::Module::Role::RequiredFramedMethods;
use Method::Frame::Domain::Module::RequiredFramedMethod;

use Class::Accessor::Lite (
    new => 0,
    ro => [qw( name )]
);

sub new {
    my ($class, %args) = @_;
    Carp::croak "Missing argument 'name'" unless $args{name};

    bless +{
        name           => $args{name},
        framed_methods => do {
            if ( exists $args{framed_methods} ) {
                my $is_framed_methods = object_isa(
                    $args{framed_methods},
                    'Method::Frame::Domain::Module::Role::FramedMethods'
                );
                $is_framed_methods
                    ? $args{framed_methods}
                    : Carp::croak q{Argument 'framed_methods' is not FramedMethods object.};
            }
            else {
                Method::Frame::Domain::Module::Role::FramedMethods->new([]);
            }
        },
        required_framed_methods => do {
            if ( exists $args{required_framed_methods} ) {
                my $is_required_framed_methods = object_isa(
                    $args{required_framed_methods},
                    'Method::Frame::Domain::Module::Role::RequiredFramedMethods'
                );
                $is_required_framed_methods
                    ? $args{required_framed_methods}
                    : Carp::croak q{Argument 'required_framed_methods' is not RequiredFramedMethods object.};
            }
            else {
                Method::Frame::Domain::Module::Role::RequiredFramedMethods->new([]);
            }
        },
    }, $class;
}

sub add_framed_method {
    Carp::croak 'Too few argument.' if @_ < 2;
    my ($self, $framed_method) = @_;
    my $is_framed_method = object_isa(
        $framed_method,
        'Method::Frame::Domain::Module::Role::FramedMethod'
    );
    Carp::croak 'Argument is not FrameMethod object.' unless $is_framed_method;

    $self->framed_methods->add($framed_method);
}

sub add_required_framed_method {
    Carp::croak 'Too few argument.' if @_ < 2;
    my ($self, $required_framed_method) = @_;
    my $is_required_framed_method = object_isa(
        $required_framed_method,
        'Method::Frame::Domain::Module::RequiredFramedMethod'
    );
    Carp::croak 'Argument is not RequiredFramedMethod object.' unless $is_required_framed_method;

    $self->required_framed_methods->add($required_framed_method);
}

sub apply {
    Carp::croak 'Too few argument' if @_ < 2;
    my ($self, $applicable) = @_;
    Carp::croak 'Argument is not applicable Object.'
        unless $applicable->DOES('Method::Frame::Domain::ApplyRole::Applicable');

    my @errors =
        map { @$_ }
        (
            $applicable->consume_framed_methods($self->{framed_methods}),
            $applicable->consume_required_framed_methods($self->{required_framed_methods}),
        );
    \@errors;
}

1;
