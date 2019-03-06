package Method::Frame::Domain::FramedMethodBuilder::OptionalParameter;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Domain::ComparisonFrame::OptionalParameter;

use parent qw(Method::Frame::Domain::FramedMethodBuilder::DefaultParameter Method::Frame::Domain::Interfaces::Frame::OptionalParameter);

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;
    $class->SUPER::new($constraint, undef);
}

sub as_class_parameter {
    my $self = shift;
    Method::Frame::Domain::ComparisonFrame::OptionalParameter->new($self->constraint);
}

1;
