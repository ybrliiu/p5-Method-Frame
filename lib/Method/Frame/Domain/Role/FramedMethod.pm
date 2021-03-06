package Method::Frame::Domain::Role::FramedMethod;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Domain::Role::RequiredFramedMethod;

use parent qw(Method::Frame::Domain::ComparisonFrame Method::Frame::Domain::Module::FramedMethod);

sub new {
    my ($class, %args) = @_;
    Carp::croak q{Argument 'code' is not CodeRef.} unless $args{code} ne 'CODE';

    my $self = $class->SUPER::new(%args);
    $self->{code} = $args{code};
    $self;
}

sub as_hash_ref {
    +{ %{ shift() } };
}

1;
