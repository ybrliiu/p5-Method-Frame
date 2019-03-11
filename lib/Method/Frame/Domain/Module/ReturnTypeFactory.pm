package Method::Frame::Domain::Module::ReturnTypeFactory;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Domain::Module::Frame::ReturnType;

sub create {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;
    Method::Frame::Domain::Module::Frame::ReturnType->new($constraint);
}

1;
