package Method::Frame::SugerBackEnd::Class;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Store::MetaClassStore;
use Method::Frame::Domain::Module::Class;
use Method::Frame::Domain::Module::FramedMethod;
use Method::Frame::Domain::Module::ParametersFactory;
use Method::Frame::Domain::Module::ReturnTypeFactory;

# alias 
use constant +{
    ParametersFactory => 'Method::Frame::Domain::Module::ParametersFactory',
    ReturnTypeFactory => 'Method::Frame::Domain::Module::ReturnTypeFactory',
};

sub add_framed_method {
    my ($class, $class_name, $method_options) = @_;

    my $meta_class = Method::Frame::Store::MetaClassStore->maybe_get($class_name)
        // Method::Frame::Domain::Module::Class->new(name => $class_name);

    my $framed_method = Method::Frame::Domain::Module::FramedMethod->new(
        name        => $method_options->{name},
        params      => ParametersFactory->create($method_options->{params}),
        return_type => ReturnTypeFactory->create($method_options->{return_type}),
        code        => $method_options->{code},
    );

    if ( my $err = $meta_class->add_framed_method($framed_method) ) {
        $err;
    }
    else {
        Method::Frame::Store::MetaClassStore->store($meta_class);
        undef;
    }
}

1;
