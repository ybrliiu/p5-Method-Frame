package Method::Frame::Domain::Module::Frame::ReturnType;

use Method::Frame::Base;

use Class::Accessor::Lite (
    new => 1,
    ro  => [qw( constraint )],
);

use Method::Frame::Domain::FramedMethodBuilder::ReturnType;

sub as_framed_method_builder {
    my $self = shift;
    Method::Frame::Domain::FramedMethodBuilder::ReturnType->new($self->{constraint});
}

1;
