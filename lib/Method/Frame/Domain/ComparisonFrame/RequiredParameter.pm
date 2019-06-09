package Method::Frame::Domain::ComparisonFrame::RequiredParameter;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util;
use Role::Tiny::With qw( with );

with qw( Method::Frame::Domain::ComparisonFrame::Parameter );

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my $class = shift;
    my $constraint = do {
        if ( 
            Scalar::Util::blessed($_[0]) &&
            $_[0]->isa('Method::Frame::Domain::Module::Frame::RequiredParameter')
        ) {
            $_[0]->constraint;
        }
        else {
            $_[0];
        }
    };

    my $err = Method::Frame::Util::ensure_type_constraint_object($constraint);
    Carp::croak $err if defined $err;

    bless +{ constraint => $constraint }, $class;
}

sub _type { 'required' }

1;
