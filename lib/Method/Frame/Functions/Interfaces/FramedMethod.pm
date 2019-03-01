package Method::Frame::Functions::Interfaces::FramedMethod;

use Method::Frame::Base;

use parent 'Method::Frame::Functions::Interfaces::Frame';

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( code )],
);

1;
