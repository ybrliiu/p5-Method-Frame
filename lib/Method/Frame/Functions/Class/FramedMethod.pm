package Method::Frame::Functions::Class::FramedMethod;

use Method::Frame::Base;

use Carp ();

use parent qw(
    Method::Frame::Functions::ComparisonFrame
    Method::Frame::Functions::Interfaces::FramedMethod
);

sub new {
    my ($class, %args) = @_;
    Carp::croak q{Argument 'code' is not CodeRef.} unless $args{code} ne 'CODE';

    my $self = $class->SUPER::new(%args);
    $self->{code} = $args{code};
    $self;
}

1;
