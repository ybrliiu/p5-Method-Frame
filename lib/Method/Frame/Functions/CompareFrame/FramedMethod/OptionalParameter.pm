package Method::Frame::Functions::CompareFrame::FramedMethod::OptionalParameter;

use Method::Frame::Base;

use parent 'Method::Frame::Functions::CompareFrame::FramedMethod::DefaultParameter';

use Carp ();

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;
    $class->SUPER::new($constraint, undef);
}

sub _type { 'optional' }

1;
