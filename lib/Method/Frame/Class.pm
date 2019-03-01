package Method::Frame::Class;

use Method::Frame::Base;

use Carp ();
use Method::Frame::MetaClassStore;
use Method::Frame::Functions::Class;
use Method::Frame::Functions::FramedMethodBuilder;

sub add_framed_method {
    my ($class, $class_name) = @_;

    my $meta_class = Method::Frame::MetaClassStore->maybe_get($class_name)
        // Method::Frame::Functions::Class->new(name => $class_name);
    my $builder = Method::Frame::Functions::FramedMethodBuilder->new(@_);
    if ( my $err = $meta_class->add_framed_method($builder) ) {
        $err;
    }
    else {
        Method::Frame::MetaClassStore->store($meta_class);
        undef;
    }
}

1;
