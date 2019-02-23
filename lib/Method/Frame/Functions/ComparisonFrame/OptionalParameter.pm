package Method::Frame::Functions::ComparisonFrame::OptionalParameter;

use Method::Frame::Base;

use parent 'Method::Frame::Functions::ComparisonFrame::DefaultParameter';

use Carp ();

# override
sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $constraint) = @_;
    $class->SUPER::new($constraint, undef);
}

# override
sub _type { 'optional' }

1;
