package Method::Frame::Functions::ComparisonFrame::RequiredParameter;

use Method::Frame::Base;

use parent qw(
    Method::Frame::Functions::ComparisonFrame::Parameter
    Method::Frame::Functions::Interfaces::Frame::RequiredParameter
);

use Carp ();
use Method::Frame::Util;

# override
sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;

    my $err = Method::Frame::Util::ensure_type_constraint_object($constraint);
    Carp::croak $err if defined $err;

    bless +{ constraint => $constraint }, $class;
}

# override
sub _type { 'required' }

1;
