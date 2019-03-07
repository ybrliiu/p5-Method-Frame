package Method::Frame::Domain::Module::FramedMethod;

use Method::Frame::Base;

use parent 'Method::Frame::Domain::Module::Frame';

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( code )],
);

1;
