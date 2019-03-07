package Method::Frame::Domain::ComparisonFrame::OptionalParameter;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();

use parent qw(Method::Frame::Domain::ComparisonFrame::DefaultParameter Method::Frame::Domain::Module::Frame::OptionalParameter);

# override
sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my $class = shift;
    my $constraint = do {
        if ( 
            Scalar::Util::blessed($_[0]) &&
            $_[0]->isa('Method::Frame::Domain::Module::Frame::OptionalParameter')
        ) {
            $_[0]->constraint;
        }
        else {
            $_[0];
        }
    };

    $class->SUPER::new($constraint, undef);
}

# override
sub _type { 'optional' }

1;
