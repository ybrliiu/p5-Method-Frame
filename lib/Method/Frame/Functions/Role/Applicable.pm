package Method::Frame::Functions::Role::Applicable;

use Method::Frame::Base;

use Carp ();

sub consume_required_framed_methods { Carp::croak 'This is abstract method.' }

sub consume_framed_methods { Carp::croak 'This is abstract method.' }

1;
