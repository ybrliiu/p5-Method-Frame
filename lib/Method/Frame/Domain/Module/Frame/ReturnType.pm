package Method::Frame::Domain::Module::Frame::ReturnType;

use Method::Frame::Base;

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( constraint )],
);

use Carp ();
use Method::Frame::Domain::FramedMethodBuilder::ReturnType;

sub new {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($class, $constraint) = @_;

    bless +{ constraint => $constraint }, $class;
}

sub as_framed_method_builder {
    my $self = shift;
    Method::Frame::Domain::FramedMethodBuilder::ReturnType->new($self->{constraint});
}

1;
