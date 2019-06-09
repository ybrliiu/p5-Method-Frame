package Method::Frame::Domain::Module::Frame::OptionalParameter;

use Method::Frame::Base;
use Method::Frame::Domain::FramedMethodBuilder::OptionalParameter;

use parent 'Method::Frame::Domain::Module::Frame::DefaultParameter';

# override
sub as_framed_method_builder {
    my $self = shift;
    Method::Frame::Domain::FramedMethodBuilder::OptionalParameter->new($self->{constraint});
}

1;
