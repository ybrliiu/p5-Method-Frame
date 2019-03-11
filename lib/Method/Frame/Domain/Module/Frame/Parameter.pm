package Method::Frame::Domain::Module::Frame::Parameter;

use Method::Frame::Base;
use Role::Tiny;
use Carp ();

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( constraint )],
);

sub new {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($class, $constraint) = @_;

    bless +{ constraint => $constraint }, $class;
}

requires 'as_framed_method_builder';

1;
