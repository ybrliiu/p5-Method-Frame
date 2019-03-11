package Method::Frame::Domain::Module::Frame::DefaultParameter;

use Method::Frame::Base;

use Class::Accessor::Lite (
    new => 1,
    ro  => [qw( default )],
);

use Role::Tiny::With qw( with );
use Method::Frame::Domain::FramedMethodBuilder::DefaultParameter;

with 'Method::Frame::Domain::Module::Frame::Parameter';

sub as_framed_method_builder {
    my $self = shift;
    Method::Frame::Domain::FramedMethodBuilder::DefaultParameter->new(
        $self->{constraint},
        $self->{default},
    );
}

1;
