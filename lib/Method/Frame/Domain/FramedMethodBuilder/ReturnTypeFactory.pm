package Method::Frame::Domain::FramedMethodBuilder::ReturnTypeFactory;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Domain::FramedMethodBuilder::ReturnType;

sub create {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;
    Method::Frame::Domain::FramedMethodBuilder::ReturnType->new($constraint);
}

1;
