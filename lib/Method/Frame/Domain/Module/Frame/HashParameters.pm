package Method::Frame::Domain::Module::Frame::HashParameters;

use Method::Frame::Base;

use parent 'Method::Frame::Domain::Module::Frame::Parameters';

use Class::Accessor::Lite (
    new => 1,
    ro  => [qw( hash )],
);

1;