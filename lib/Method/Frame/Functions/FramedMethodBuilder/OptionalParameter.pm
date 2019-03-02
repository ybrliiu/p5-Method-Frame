package Method::Frame::Functions::FramedMethodBuilder::OptionalParameter;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Functions::ComparisonFrame::OptionalParameter;

use parent qw(
    Method::Frame::Functions::FramedMethodBuilder::DefaultParameter
    Method::Frame::Functions::Interfaces::Frame::OptionalParameter
);

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;
    $class->SUPER::new($constraint, undef);
}

sub as_class_parameter {
    my $self = shift;
    Method::Frame::Functions::ComparisonFrame::OptionalParameter->new($self->constraint);
}

1;
