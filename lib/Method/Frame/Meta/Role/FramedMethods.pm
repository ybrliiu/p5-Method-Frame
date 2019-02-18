package Method::Frame::Meta::Role::FramedMethods;

use Method::Frame::Base;

use parent 'Method::Frame::Meta::Module::FramedMethods';

sub remove {
    my ($self, $framed_method) = @_;
    Carp::croak 'Argument value must be FramedMethod object.'
        unless $framed_method->isa('Method::Frame::Meta::Module::FramedMethod');

    if ( $self->exists($framed_method) ) {
        delete $self->{ $framed_method->name };
        undef;
    }
    else {
        "FramedMethod '@{[ $framed_method->name ]}' does not exists";
    }
}

1;
