package Method::Frame::Util;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();

use Exporter qw( import );
our @EXPORT = qw( object_isa validate_argument_object_type );

sub ensure_type_constraint_object {
    my $constraint = shift;
    for my $required_method (qw[ name equals check get_message ]) {
        return "Constraint object '$constraint' can not call $required_method"
            unless Scalar::Util::blessed($constraint) && $constraint->can($required_method)
    }
    undef;
}

sub object_isa {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($object, $class_name) = @_;
    Scalar::Util::blessed($object) && $object->isa($class_name);
}

sub validate_argument_object_type {
    Carp::croak 'Too few arguments.' if @_ < 2;

    # For show error log
    # (エラーが起きた時はこの関数を呼び出した関数の呼び出し元で失敗しているように見せたい)
    local $Carp::Internal{ caller() } = 1;

    if (@_ == 2) {
        my ($object, $class_name) = @_;
        Carp::croak "Argument must be $class_name object." unless object_isa($object, $class_name);
    }
    else {
        my ($arg_name, $object, $class_name) = @_;
        Carp::croak "Argument '$arg_name' is not $class_name object."
            unless object_isa($object, $class_name);
    }
}

1;
