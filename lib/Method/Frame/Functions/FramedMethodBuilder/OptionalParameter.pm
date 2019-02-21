package Method::Frame::Functions::FramedMethodBuilder::OptionalParameter;

use Method::Frame::Base;

use parent 'Method::Frame::Functions::FramedMethodBuilder::DefaultParameter';

use Carp ();

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;
    $class->SUPER::new($constraint, undef);
}

1;