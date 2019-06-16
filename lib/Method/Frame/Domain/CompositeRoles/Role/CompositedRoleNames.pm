package Method::Frame::Domain::CompositeRoles::Role::CompositedRoleNames;

use Method::Frame::Base;
use Method::Frame::Util qw( validate_argument_object_type );

sub new {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($class, $composited_role_names) = @_;
    Carp::croak 'Argument is not ArrayRef.' unless ref $composited_role_names eq 'ARRAY';
    bless [ @$composited_role_names ], $class;
}

sub composite {
    Carp::croak 'Too few arguments.' if @_ < 3;
    my ($self, $composited_role_name, $to_composite) = @_;
    validate_argument_object_type($to_composite, __PACKAGE__);

    my @composite_all = ( @$self, $composited_role_name, @$to_composite );
    my %set;
    $set{$_} = undef for @composite_all;
    (ref $self)->new([ keys %set ]);
}

1;
