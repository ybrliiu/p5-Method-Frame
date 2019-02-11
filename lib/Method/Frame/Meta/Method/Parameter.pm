package Method::Frame::Meta::Method::Parameter;
use 5.014004;
use strict;
use warnings;
use utf8;

use Carp ();
use Scalar::Util ();

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( constraint )],
);

sub new { Carp::croak 'This is abstract method.' }

sub validate { Carp::croak 'This is abstract method.' }

1;
