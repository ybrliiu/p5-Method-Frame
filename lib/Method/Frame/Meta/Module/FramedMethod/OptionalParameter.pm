package Method::Frame::Meta::Module::FramedMethod::OptionalParameter;

use Method::Frame::Base;

use parent 'Method::Frame::Meta::Module::FramedMethod::DefaultParameter';

use Carp ();
use Scalar::Util ();
use Method::Frame::Util;

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;
    $class->SUPER::new($constraint, undef);
}

1;
