package Method::Frame::Domain::Interfaces::FramedMethod;

use Method::Frame::Base;

use parent 'Method::Frame::Domain::Interfaces::Frame';

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( code )],
);

1;
