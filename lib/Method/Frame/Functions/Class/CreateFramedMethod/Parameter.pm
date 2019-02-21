package Method::Frame::Functions::Class::CreateFramedMethod::Parameter;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( constraint )],
);

sub new { Carp::croak 'This is abstract method.' }

sub validate { Carp::croak 'This is abstract method.' }

1;
