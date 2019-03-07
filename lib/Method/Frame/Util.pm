package Method::Frame::Util;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();

use Exporter qw( import );
our @EXPORT = qw( object_isa );

sub ensure_type_constraint_object {
    my $constraint = shift;
    for my $required_method (qw[ name equals check get_message ]) {
        return "constraint object '$constraint' can not call $required_method"
            unless Scalar::Util::blessed($constraint) && $constraint->can($required_method)
    }
    undef;
}

sub object_isa {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($object, $class_name) = @_;
    Scalar::Util::blessed($object) && $object->isa($class_name);
}

1;
