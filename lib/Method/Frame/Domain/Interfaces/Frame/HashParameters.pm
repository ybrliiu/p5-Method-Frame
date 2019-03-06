package Method::Frame::Domain::Interfaces::Frame::HashParameters;

use Method::Frame::Base;

use parent 'Method::Frame::Domain::Interfaces::Frame::Parameters';

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( hash )],
);

1;
