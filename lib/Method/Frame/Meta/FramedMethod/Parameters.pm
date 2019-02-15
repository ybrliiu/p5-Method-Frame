package Method::Frame::Meta::FramedMethod::Parameters;

use Method::Frame::Base;

use Carp ();

sub abstract_err { Carp::croak 'This is abstract method.' }

sub new { $_[0]->abstract_err }

sub validate { $_[0]->abstract_err }

sub valid_args { $_[0]->abstract_err }

1;
