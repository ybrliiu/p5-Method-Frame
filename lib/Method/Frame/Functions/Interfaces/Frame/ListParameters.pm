package Method::Frame::Functions::Interfaces::Frame::ListParameters;

use Method::Frame::Base;

use parent 'Method::Frame::Functions::Interfaces::Frame::Parameters';

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( list num )],
);

1;
