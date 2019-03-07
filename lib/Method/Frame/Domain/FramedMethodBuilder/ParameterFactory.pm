package Method::Frame::Domain::FramedMethodBuilder::ParameterFactory;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util;
use Method::Frame::Domain::FramedMethodBuilder::RequiredParameter;
use Method::Frame::Domain::FramedMethodBuilder::DefaultParameter;
use Method::Frame::Domain::FramedMethodBuilder::OptionalParameter;

sub create {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $arg) = @_;

    if ( !(defined Method::Frame::Util::ensure_type_constraint_object($arg) ) ) {
        Method::Frame::Domain::FramedMethodBuilder::RequiredParameter->new($arg);
    }
    elsif ( ref $arg eq 'HASH' ) {
        $class->create_from_hash_ref($arg);
    }
    else {
        Carp::confess 'Invalid parameter option passed.';
    }
}

sub create_from_hash_ref {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $args) = @_;

    my $err = Method::Frame::Util::ensure_type_constraint_object($args->{isa});
    Carp::confess $err if defined $err;

    if ( exists $args->{default} ) {
        Method::Frame::Domain::FramedMethodBuilder::DefaultParameter
            ->new( $args->{isa}, $args->{default} );
    }
    elsif ( !!$args->{optional} ) {
        Method::Frame::Domain::FramedMethodBuilder::OptionalParameter->new($args->{isa});
    }
    else {
        Method::Frame::Domain::FramedMethodBuilder::RequiredParameter->new($args->{isa});
    }
}

1;
