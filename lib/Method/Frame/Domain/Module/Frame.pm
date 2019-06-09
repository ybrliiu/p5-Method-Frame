package Method::Frame::Domain::Module::Frame;

use Method::Frame::Base;
use Role::Tiny;

use Class::Accessor::Lite (
    new => 1,
    ro  => [qw( name params return_type )],
);

1;
