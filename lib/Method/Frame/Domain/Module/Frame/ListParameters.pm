package Method::Frame::Domain::Module::Frame::ListParameters;

use Method::Frame::Base;

use parent 'Method::Frame::Domain::Module::Frame::Parameters';

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( list num )],
);

1;
