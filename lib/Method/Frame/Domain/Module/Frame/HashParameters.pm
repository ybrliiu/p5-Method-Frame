package Method::Frame::Domain::Module::Frame::HashParameters;

use Method::Frame::Base;

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( hash )],
);

use Role::Tiny::With qw( with );
use Method::Frame::Domain::FramedMethodBuilder::HashParameters;

with 'Method::Frame::Domain::Module::Frame::Parameters';

sub new {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($class, $hash) = @_;

    bless +{ hash => $hash }, $class;
}

sub as_framed_method_builder {
    my $self = shift;
    my %hash =
        map { $_ => $self->{hash}->{$_}->as_framed_method_builder() }
        keys %{ $self->{hash} };
    Method::Frame::Domain::FramedMethodBuilder::HashParameters->new(\%hash);
}

1;
