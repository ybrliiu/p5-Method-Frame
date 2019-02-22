package Method::Frame::Functions::FramedMethodBuilder::Parameters;

use Method::Frame::Base;

use Carp ();

sub new { Carp::croak 'This is abstract method.' }

sub validate { Carp::croak 'This is abstract method.' }

1;
