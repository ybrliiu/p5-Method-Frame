package Method::Frame::Domain::FramedMethodBuilder::Parameter;

use Method::Frame::Base;
use Role::Tiny;

requires 'new';

requires 'validate';

sub _failed_message {
    my ($self, $argument) = @_;
    qq{Parameter does not pass type constraint '$self->{constraint}' }
        . qq{because : Argument value is '$argument'.};
}

1;
