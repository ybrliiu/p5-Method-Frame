package Method::Frame::Util;
use 5.014004;
use strict;
use warnings;
use utf8;

use Carp ();
use Scalar::Util ();

sub ensure_type_constraint_object {
    my $constraint = shift;
    for my $required_method (qw[ check get_message ]) {
        return "constraint object '$constraint' can not call $required_method"
            if !Scalar::Util::blessed($constraint) || !$constraint->can($required_method)
    }
    undef;
}

1;
