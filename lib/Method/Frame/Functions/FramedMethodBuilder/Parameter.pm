package Method::Frame::Functions::FramedMethodBuilder::Parameter;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( constraint )],
);

sub new { Carp::croak 'This is abstract method.' }

sub validate { Carp::croak 'This is abstract method.' }

sub _failed_message {
    my ($self, $argument) = @_;
    qq{Parameter does not pass type constraint '@{[ $self->constraint ]}' }
        . qq{because : Argument value is '$argument'.};
}

1;