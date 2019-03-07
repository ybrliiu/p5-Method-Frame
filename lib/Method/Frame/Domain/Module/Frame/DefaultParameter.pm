package Method::Frame::Domain::Module::Frame::DefaultParameter;

use Method::Frame::Base;

use parent 'Method::Frame::Domain::Module::Frame::Parameter';

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( default )],
);

1;
