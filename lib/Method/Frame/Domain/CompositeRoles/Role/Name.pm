package Method::Frame::Domain::CompositeRoles::Role::Name;

use Method::Frame::Base;
use Carp ();
use Method::Frame::Util qw( validate_argument_object_type );

sub new {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($class, $name) = @_;
    bless \$name, $class;
}

sub composite {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $to_composite) = @_;
    validate_argument_object_type($to_composite, __PACKAGE__);

    if ($$self eq $$to_composite) {
        (undef, 'Can not composite with myself.');
    }
    else {
        ($to_composite, undef);
    }
}

1;
