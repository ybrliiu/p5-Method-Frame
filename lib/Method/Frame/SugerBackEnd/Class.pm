package Method::Frame::SugerBackEnd::Class;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Store::MetaClassStore;
use Method::Frame::Functions::Class;
use Method::Frame::Functions::FramedMethodBuilder;
use Method::Frame::Functions::FramedMethodBuilder::ParametersFactory;
use Method::Frame::Functions::FramedMethodBuilder::ReturnTypeFactory;

# alias 
use constant +{
    ParametersFactory => 'Method::Frame::Functions::FramedMethodBuilder::ParametersFactory',
    ReturnTypeFactory => 'Method::Frame::Functions::FramedMethodBuilder::ReturnTypeFactory',
};

sub add_framed_method {
    my ($class, $class_name, $method_options) = @_;

    my $meta_class = Method::Frame::Store::MetaClassStore->maybe_get($class_name)
        // Method::Frame::Functions::Class->new(name => $class_name);

    my $builder = Method::Frame::Functions::FramedMethodBuilder->new(
        name        => $method_options->{name},
        params      => ParametersFactory->create($method_options->{params}),
        return_type => ReturnTypeFactory->create($method_options->{return_type}),
        code        => $method_options->{code},
    );

    if ( my $err = $meta_class->add_framed_method($builder) ) {
        $err;
    }
    else {
        Method::Frame::Store::MetaClassStore->store($meta_class);
        undef;
    }
}

1;
