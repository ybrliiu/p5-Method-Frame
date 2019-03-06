package Method::Frame::Domain::Interfaces::Frame::DefaultParameter;

use Method::Frame::Base;

use parent 'Method::Frame::Domain::Interfaces::Frame::Parameter';

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( default )],
);

1;
