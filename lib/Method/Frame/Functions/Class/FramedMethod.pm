package Method::Frame::Functions::Class::FramedMethod;

use Method::Frame::Base;

use Carp ();

use parent qw(
    Method::Frame::Functions::ComparisonFrame
    Method::Frame::Functions::Interfaces::FramedMethod
);

sub new {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($class, $framed_method) = @_;
    Carp::croak 'Parameter does not FrameMethod object.'
        unless $framed_method->isa('Method::Frame::Functions::Interfaces::FramedMethod');

    my $self = $class->SUPER::new(%$framed_method);
    $self->{code} = $framed_method->code;
    $self;
}

1;
