package Method::Frame::Domain::Module::Class::FramedMethod;

use Method::Frame::Base;

use Carp ();

use parent qw(Method::Frame::Domain::ComparisonFrame Method::Frame::Domain::Module::FramedMethod);

sub new {
    my ($class, %args) = @_;
    Carp::croak q{Argument 'code' is not CodeRef.} unless $args{code} ne 'CODE';

    my $self = $class->SUPER::new(%args);
    $self->{code} = $args{code};
    $self;
}

1;
