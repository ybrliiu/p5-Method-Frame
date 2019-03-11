package Method::Frame::Domain::Module::Frame::Parameter;

use Method::Frame::Base;
use Role::Tiny;

use Class::Accessor::Lite (
    new => 1,
    ro  => [qw( constraint )],
);

requires 'as_framed_method_builder';

1;
