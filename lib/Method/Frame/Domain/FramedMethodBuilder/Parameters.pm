package Method::Frame::Domain::FramedMethodBuilder::Parameters;

use Method::Frame::Base;

use Carp ();

use parent 'Method::Frame::Domain::Module::Frame::Parameters';

sub new { Carp::croak 'This is abstract method.' }

sub validate { Carp::croak 'This is abstract method.' }

sub as_class_parameters { Carp::croak 'This is abstract method.' }

1;
