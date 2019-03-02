package Method::Frame::Functions::FramedMethodBuilder::Parameters;

use Method::Frame::Base;

use Carp ();

use parent 'Method::Frame::Functions::Interfaces::Frame::Parameters';

sub new { Carp::croak 'This is abstract method.' }

sub validate { Carp::croak 'This is abstract method.' }

sub as_class_parameters { Carp::croak 'This is abstract method.' }

1;
