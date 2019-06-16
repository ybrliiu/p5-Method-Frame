package Method::Frame::SugerBackEnd::Role;

use Method::Frame::Base;

use Carp ();
use Class::Load ();
use Method::Frame::Store::MetaRoleStore;
use Method::Frame::Domain::Module::Role;
use Method::Frame::Domain::Module::FramedMethod;
use Method::Frame::Domain::Module::RequiredFramedMethod;
use Method::Frame::Domain::Module::ParametersFactory;
use Method::Frame::Domain::Module::ReturnTypeFactory;

# alias 
use constant +{
    ParametersFactory => 'Method::Frame::Domain::Module::ParametersFactory',
    ReturnTypeFactory => 'Method::Frame::Domain::Module::ReturnTypeFactory',
};

sub add_framed_method {
    Carp::croak 'Too few arguments.' if @_ < 3;
    my ($class, $role_name, $method_options) = @_;

    my $meta_role = Method::Frame::Store::MetaRoleStore->maybe_get($role_name)
        // Method::Frame::Domain::Role->new(name => $role_name);

    my $framed_method = Method::Frame::Domain::Module::FramedMethod->new(
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
    Carp::croak 'Too few arguments.' if @_ < 3;
    my ($class, $role_name, $method_options) = @_;

    my $meta_role = Method::Frame::Store::MetaRoleStore->maybe_get($role_name)
        // Method::Frame::Domain::Role->new(name => $role_name);

    my $required_framed_method = Method::Frame::Domain::Module::RequiredFramedMethod->new(
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

sub consume_roles {
    Carp::croak 'Too few arguments.' if @_ < 3;
    my ($class, $consumer_name, $consume_role_names) = @_;

    my @consume_roles = map {
        Method::Frame::Store::MetaRoleStore->maybe_get($_)
            or Carp::confess "MetaRole $_ does not exists."
    } @$consume_role_names;

    my $consumer = Method::Frame::Store::MetaRoleStore->maybe_get($consumer_name)
        // Method::Frame::Domain::Role->new(name => $consumer_name);

    # 一旦合成ロール作成
    # 合成したロールをconsumerに適用

    my @errors = map { @{ $_->apply($consumer) } } @consume_roles;
    \@errors;
}

sub with {
    Carp::croak 'Too few arguments.' if @_ < 3;
    my ($class, $consumer_name, $consume_role_names) = @_;

    Class::Load::load_class($_) for @$consume_role_names;

    $class->consume_roles($consumer_name, @$consume_role_names);
}

1;
