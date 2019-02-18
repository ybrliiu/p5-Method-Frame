package Method::Frame::Util;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();

sub ensure_type_constraint_object {
    my $constraint = shift;
    for my $required_method (qw[ name equals check get_message ]) {
        return "constraint object '$constraint' can not call $required_method"
            if !Scalar::Util::blessed($constraint) || !$constraint->can($required_method)
    }
    undef;
}

1;
