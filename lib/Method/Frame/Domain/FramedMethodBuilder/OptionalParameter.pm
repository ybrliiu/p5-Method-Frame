package Method::Frame::Domain::FramedMethodBuilder::OptionalParameter;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Domain::Module::Frame::OptionalParameter;
use Role::Tiny::With qw( with );

use parent 'Method::Frame::Domain::FramedMethodBuilder::DefaultParameter';

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;
    $class->SUPER::new($constraint, undef);
}

sub as_module_parameter {
    my $self = shift;
    Method::Frame::Domain::Module::Frame::OptionalParameter->new($self->{constraint});
}

1;
