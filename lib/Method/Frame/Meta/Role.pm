package Method::Frame::Meta::Role;

use Method::Frame::Base;

use parent 'Method::Frame::Meta::Module';
use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( abstract_framed_methods )],
);

use Carp ();
use Method::Frame::Meta::Role::FramedMethods;
use Method::Frame::Meta::Role::AbstractFramedMethods;

# override
sub new {
    my ($class, %args) = @_;
    $args{framed_methods}          //= Method::Frame::Meta::Role::FramedMethods->new;
    $args{abstract_framed_methods} //= Method::Frame::Meta::Role::AbstractFramedMethods->new;

    Carp::croak 'Argument must be FramedMethods object'
        unless $args{framed_methods}->isa('Method::Frame::Meta::Role::FramedMethods');
    Carp::croak 'Argument must be AbstractFramedMethods object'
        unless $args{abstract_framed_methods}->isa('Method::Frame::Meta::Role::AbstractFramedMethods');

    my $self = $class->SUPER::new(%args);
    $self->{framed_methods}          = $args{framed_methods};
    $self->{abstract_framed_methods} = $args{abstract_framed_methods};
    $self;
}

# override
sub add_framed_method {
    my ($self, $framed_method) = @_;
    Carp::croak 'Too few arguments' if @_ < 2;
    Carp::croak 'Argument must be FramedMethod object'
        unless $framed_method->isa('Method::Frame::Meta::Module::FramedMethod');

    my $maybe_err = $self->framed_methods->add($framed_method);
    if (
        defined $maybe_err &&
        $maybe_err eq "FramedMethod '@{[ $framed_method->name ]}' does not exists"
    ) {
        $self->framed_methods->remove($framed_method);
        $self->abstract_framed_method->add($framed_method->to_abstract());
    }

    undef;
}

sub add_abstract_framed_method {
    my ($self, $abstract_framed_method) = @_;
    Carp::croak 'Argument must be AbstractFramedMethod object'
        unless $abstract_framed_method->isa('Method::Frame::Meta::Module::AbstractFramedMethod');

    my $maybe_err = $self->abstract_framed_methods->add($abstract_framed_method);
}

sub apply_framed_methods_to_role {
    my ($self, $framed_methods) = @_;
    Carp::croak 'Argument must be FramedMethods object'
        unless $framed_methods->isa('Method::Frame::Meta::Role::FramedMethods');

    for my $framed_method (@{ $self->framed_methods }) {
        my $maybe_err = $framed_methods->add($framed_method);
        return $maybe_err if defined $maybe_err;
    }
    undef;
}

sub apply_abstract_framed_methods_to_class {
    my ($self, $framed_methods) = @_;
    Carp::croak 'Argument must be FramedMethods object'
        unless $framed_methods->isa('Method::Frame::Meta::Class::FramedMethods');

    for my $abstract_framed_method (@{ $self->abstract_framed_methods }) {
        my $maybe_err = $framed_methods->implement($abstract_framed_method);
        return $maybe_err if defined $maybe_err;
    }
    undef;
}

sub apply_abstract_framed_methods_to_role {
    my ($self, $abstract_framed_methods) = @_;
    Carp::croak 'Argument must be AbstractFramedMethods object'
        unless $abstract_framed_methods->isa('Method::Frame::Meta::Role::AbstractFramedMethods');

    for my $abstract_framed_method (@{ $self->abstract_framed_methods }) {
        my $maybe_err = $abstract_framed_methods->add($abstract_framed_method);
        return $maybe_err if defined $maybe_err;
    }
    undef;
}

# override
sub consume_role {
    my ($self, $role) = @_;
    Carp::croak 'Argument must be MetaRole object' unless $role->isa(__PACKAGE__);

    push @{ $self->applied_role_names }, $role->name;

    for my $maybe_err (
        $role->apply_framed_methods( $self->framed_methods ),
        $role->apply_abstract_framed_methods_to_role( $self->abstract_framed_methods )
    ) {
        return $maybe_err if defined $maybe_err;
    }

    undef;
}

1;
