package Method::Frame::Domain::Module::FramedMethod;

use Method::Frame::Base;

use Class::Accessor::Lite (
    new => 1,
    ro  => [qw( code )],
);

use Carp ();
use Role::Tiny::With qw( with );
use Method::Frame::Domain::FramedMethodBuilder;

with 'Method::Frame::Domain::Module::Frame';

sub as_framed_method_builder {
    my $self = shift;
    Method::Frame::Domain::FramedMethodBuilder->new(
        name        => $self->{name},
        params      => $self->{params}->as_framed_method_builder(),
        return_type => $self->{return_type}->as_framed_method_builder(),
        code        => $self->{code},
    );
}

1;
