package Method::Frame::Store::MetaModuleStore;

use Method::Frame::Base;

use Carp ();

sub maybe_get { Carp::croak 'This is abstract method.' }

sub store { Carp::croak 'This is abstract method.' }

1;
