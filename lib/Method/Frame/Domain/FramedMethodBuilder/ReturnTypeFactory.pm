package Method::Frame::Domain::FramedMethodBuilder::ReturnTypeFactory;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util;
use Method::Frame::Domain::FramedMethodBuilder::ReturnType;

sub create {
    my ($class, $constraint) = @_;
    Method::Frame::Domain::FramedMethodBuilder::ReturnType->new($constraint);
}

1;
