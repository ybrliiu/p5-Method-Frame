package Method::Frame::Functions::Role::Applicable;

use Method::Frame::Base;

use Carp ();

sub consume_required_framed_methods { Carp::croak 'This is abstract method.' }

sub are_required_framed_methods_implemented {
    my ($self, $required_framed_methods) = @_;
    my ($are_implemented, $errors) =
        $required_framed_methods->are_implemented($self->framed_methods);
    ($are_implemented, $errors);
}

sub consume_framed_methods { Carp::croak 'This is abstract method.' }

1;
