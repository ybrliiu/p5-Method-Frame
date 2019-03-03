package Method::Frame::Functions::Role::ReturnTypeFactory;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util;
use Method::Frame::Functions::ComparisonFrame::ReturnType;

sub create {
    my ($class, $constraint) = @_;
    Method::Frame::Functions::ComparisonFrame::ReturnType->new($constraint);
}

1;
