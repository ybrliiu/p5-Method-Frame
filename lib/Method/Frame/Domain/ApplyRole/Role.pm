package Method::Frame::Domain::ApplyRole::Role;

use Method::Frame::Base;
use Role::Tiny::With qw( with );
use Class::Method::Modifiers qw( around );
use Method::Frame::Util;

with 'Method::Frame::Domain::ApplyRole::Applicable';

around new => sub {
    my ($orig, $class, %args) = @_;

    Carp::croak "Argument 'name' is required." unless exists $args{name};

    Method::Frame::Util::validate_argument_object_type(
        framed_methods => $args{framed_methods},
        'Method::Frame::Domain::ApplyRole::Role::FramedMethods',
    );

    Method::Frame::Util::validate_argument_object_type(
        required_framed_methods => $args{required_framed_methods},
        'Method::Frame::Functions::Role::RequiredFramedMethods'
    );

    my $self = $class->$orig(%args);
    $self->{$_} = $args{$_} for qw( name framed_methods required_framed_methods );
    $self;
};

sub is_name_equals {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $role_name) = @_;
    $self->{name} eq $role_name;
}

sub consume_framed_methods {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $framed_methods) = @_;

    my ($collision_framed_methods, $apply_errors) = $self->{framed_methods}->apply($framed_methods);
    return $apply_errors if @$apply_errors > 0;

    my @errors = do {
        if ( @$collision_framed_methods > 0 ) {
            my @required_framed_methods =
                map { Method::Frame::Functions::Role::RequiredFramedMethod->new($_->as_hash_ref()) }
                @$collision_framed_methods;
            my @add_errors =
                grep { defined $_ }
                map { $self->{required_framed_methods}->add($_) }
                @required_framed_methods;
        }
        else {
            ();
        }
    };

    \@errors;
}

sub consume_required_framed_methods {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $required_framed_methods) = @_;

    my $apply_errors = $self->{required_framed_methods}->apply($required_framed_methods);

    my (undef, $implemented_errors) =
        $self->are_required_framed_methods_implemented($self->{required_framed_methods});

    [ @$apply_errors, @$implemented_errors ];
}

1;
