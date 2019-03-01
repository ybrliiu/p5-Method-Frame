package Method::Frame::Functions::ComparisonFrame::OptionalParameter;

use Method::Frame::Base;

use Carp ();

use parent qw(
    Method::Frame::Functions::ComparisonFrame::DefaultParameter
    Method::Frame::Functions::Interfaces::Frame::OptionalParameter
);

# override
sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;
    $class->SUPER::new($constraint, undef);
}

# override
sub _type { 'optional' }

1;
