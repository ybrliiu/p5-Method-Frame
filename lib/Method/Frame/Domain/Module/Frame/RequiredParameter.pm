package Method::Frame::Domain::Module::Frame::RequiredParameter;

use Method::Frame::Base;
use Role::Tiny::With qw( with );
use Method::Frame::Domain::FramedMethodBuilder::RequiredParameter;

with 'Method::Frame::Domain::Module::Frame::Parameter';

sub as_framed_method_builder {
    my $self = shift;
    Method::Frame::Domain::FramedMethodBuilder::RequiredParameter->new($self->{constraint});
}

1;
