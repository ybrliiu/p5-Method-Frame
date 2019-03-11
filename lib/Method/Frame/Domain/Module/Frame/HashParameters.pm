package Method::Frame::Domain::Module::Frame::HashParameters;

use Method::Frame::Base;

use Class::Accessor::Lite (
    new => 1,
    ro  => [qw( hash )],
);

use Role::Tiny::With qw( with );
use Method::Frame::Domain::FramedMethodBuilder::HashParameters;

with 'Method::Frame::Domain::Module::Frame::Parameters';

sub as_framed_method_builder {
    my $self = shift;
    my %hash = map { $_ => $_->as_framed_method_builder() } keys %{ $self->{hash} };
    Method::Frame::Domain::FramedMethodBuilder::HashParameters->new(\%hash);
}

1;
