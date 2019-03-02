package Method::Frame::Functions::FramedMethodBuilder::ReturnTypeFactory;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util;
use Method::Frame::Functions::FramedMethodBuilder::ReturnType;

sub create {
    my ($class, $constraint) = @_;
    Method::Frame::Functions::FramedMethodBuilder::ReturnType->new($constraint);
}

1;
