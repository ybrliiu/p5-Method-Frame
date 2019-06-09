package Method::Frame::SugerBackEnd::Role;

use Method::Frame::Base;

use Carp ();
use Class::Load ();
use Method::Frame::Store::MetaRoleStore;
use Method::Frame::Domain::Role;
use Method::Frame::Domain::Role::FramedMethod;
use Method::Frame::Domain::Role::RequiredFramedMethod;
# use Method::Frame::Functions::Role::ParametersFactory;
# use Method::Frame::Functions::Role::ReturnTypeFactory;

sub add_framed_method {
    my ($class, $role_name, $method_options) = @_;

    my $meta_role = Method::Frame::Store::MetaRoleStore->maybe_get($role_name)
        // Method::Frame::Domain::Role->new(name => $role_name);

    my $framed_method = Method::Frame::Domain::Role::FramedMethod->new(
        name        => $method_options->{name},
        params      => ParametersFactory->create($method_options->{params}),
        return_type => ReturnTypeFactory->create($method_options->{return_type}),
        code        => $method_options->{code},
    );

    if ( my $err = $meta_role->add_framed_method($framed_method) ) {
        $err;
    }
    else {
        Method::Frame::Store::MetaRoleStore->store($meta_role);
        undef;
    }
}

sub add_required_framed_method {
    my ($class, $role_name, $method_options) = @_;

    my $meta_role = Method::Frame::Store::MetaRoleStore->maybe_get($role_name)
        // Method::Frame::Domain::Role->new(name => $role_name);

    my $required_framed_method = Method::Frame::Domain::Role::RequiredFramedMethod->new(
        name        => $method_options->{name},
        params      => ParametersFactory->create($method_options->{params}),
        return_type => ReturnTypeFactory->create($method_options->{return_type}),
    );

    if ( my $err = $meta_role->add_required_framed_method($required_framed_method) ) {
        $err;
    }
    else {
        Method::Frame::Store::MetaRoleStore->store($meta_role);
        undef;
    }
}

sub consume_role {
    my ($class, $consumer_name, @consume_roles_name) = @_;

    if ( grep { $consumer_name eq $_ } @consume_roles_name ) {
        Carp::confess "Cannot consume role from itself.";
    }

    Class::Load::load_class($_) for @consume_roles_name;

    my @consume_roles = map {
        Method::Frame::Store::MetaRoleStore->maybe_get($_) // Carp::confess "MetaRole $_ does not exists."
    } @consume_roles_name;

    my $consumer = Method::Frame::Store::MetaRoleStore->maybe_get($consumer_name)
        // Method::Frame::Domain::Role->new(name => $consumer_name);

    my @errors = map { @{ $_->apply($consumer) } } @consume_roles;
    \@errors;
}

1;
