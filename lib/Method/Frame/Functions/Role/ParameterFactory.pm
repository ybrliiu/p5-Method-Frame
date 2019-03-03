package Method::Frame::Functions::Role::ParameterFactory;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util;
use Method::Frame::Functions::ComparisonFrame::RequiredParameter;
use Method::Frame::Functions::ComparisonFrame::RequiredParameter;
use Method::Frame::Functions::ComparisonFrame::DefaultParameter;
use Method::Frame::Functions::ComparisonFrame::OptionalParameter;

sub create {
    my ($class, $arg) = @_;

    if ( !(defined Method::Frame::Util::ensure_type_constraint_object($arg) ) ) {
        Method::Frame::Functions::ComparisonFrame::RequiredParameter->new($arg);
    }
    elsif ( ref $arg eq 'HASH' ) {
        $class->create_from_hash_ref($arg);
    }
    else {
        Carp::confess 'Invalid parameter option passed.';
    }
}

sub create_from_hash_ref {
    my ($class, $args) = @_;

    my $err = Method::Frame::Util::ensure_type_constraint_object($args->{isa});
    Carp::confess $err if defined $err;

    if ( exists $args->{default} ) {
        Method::Frame::Functions::ComparisonFrame::DefaultParameter
            ->new( $args->{isa}, $args->{default} );
    }
    elsif ( !!$args->{optional} ) {
        Method::Frame::Functions::ComparisonFrame::OptionalParameter->new($args->{isa});
    }
    else {
        Method::Frame::Functions::ComparisonFrame::RequiredParameter->new($args->{isa});
    }
}

1;
