package Method::Frame::Domain::CompositeRoles::Role;

use Method::Frame::Base;
use Method::Frame::Util qw( validate_argument_object_type );
use Carp ();
use List::Util qw( reduce );

use constant + {
    Name                  => 'Method::Frame::Domain::CompositeRoles::Role::Name',
    CompositedRoleNames   => 'Method::Frame::Domain::CompositeRoles::Role::CompositedRoleNames',
    FramedMethods         => 'Method::Frame::Domain::CompositeRoles::Role::FramedMethods',
    ConflictedMethods     => 'Method::Frame::Domain::CompositeRoles::Role::ConflictedMethods',
    RequiredFramedMethods => 'Method::Frame::Domain::CompositeRoles::Role::RequiredFramedMethods',
};

sub new {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($class, $args) = @_;

    my %fields = do {
        if ( $args->isa('Method::Frame::Domain::Module::Role') ) {
            my $role = $args;
            (
                name                  => Name->new($role->name),
                composited_role_names => CompositedRoleNames->new($role->consumed_role_names),
                framed_methods        => FramedMethods->new($role->framed_methods),
                conflicted_methods    => ConflictedMethods->new([]),
                required_framed_methods =>
                    RequiredFramedMethods->new($role->required_framed_methods),
            );
        }
        elsif ( ref $args eq 'HASH' ) {
            (
                name => do {
                    validate_argument_object_type(name => $args->{name}, Name);
                    $args->{name};
                },
                composited_role_names => do {
                    validate_argument_object_type(
                        composited_role_names => $args->{composited_role_names},
                        CompositedRoleNames
                    );
                    $args->{composited_role_names};
                },
                framed_methods => do {
                    validate_argument_object_type(
                        framed_methods => $args->{framed_methods},
                        FramedMethods
                    );
                    $args->{framed_methods};
                },
                conflicted_methods => do {
                    validate_argument_object_type(
                        conflicted_methods => $args->{conflicted_methods},
                        ConflictedMethods,
                    );
                    $args->{conflicted_methods};
                },
                required_framed_methods => do {
                    validate_argument_object_type(
                        required_framed_methods => $args->{required_framed_methods},
                        RequiredFramedMethods,
                    );
                    $args->{required_framed_methods};
                },
            );
        }
        else {
            Carp::croak 'Invalid argument.';
        }
    };

    bless \%fields, $class;
}

sub composite {
    my ($self, $to_composite) = @_;
    validate_argument_object_type($to_composite, __PACKAGE__);

    my ($compositable_role_name, $name_err) = $self->{name}->composite($to_composite->{name});
    return $name_err if defined $name_err;

    my $composited_role_names = $self->{composited_role_names}->composite(
        $compositable_role_name,
        $to_composite->{composited_role_names}
    );

    my ($composited_framed_methods, $conflicted_methods, $framed_methods_err)
        = $self->{framed_methods}->composite($to_composite->{framed_methods});
    return $framed_methods_err if defined $framed_methods_err;

    my $composited_conflicted_methods =
        reduce {
            my ($confilcted_methods, $err) = $a->composite($b);
            return $err if defined $err;
            $confilcted_methods;
        }
        ($self->{conflicted_methods}, $to_composite->{conflicted_methods}, $conflicted_methods);

    my ($composited_required_framed_methods, $required_framed_methods_err)
        = $self->{required_framed_methods}->composite($to_composite->{required_framed_methods});
    return $required_framed_methods_err if defined $required_framed_methods_err;

    (ref $self)->new(
        composited_name         => $self->{name},
        composited_role_names   => $composited_role_names,
        framed_methods          => $composited_framed_methods,
        conflicted_methods      => $composited_conflicted_methods,
        required_framed_methods => $composited_required_framed_methods,
    );
}

sub to_module {
    my $self = shift;
    # conflicted_methods が 1以上なら変換できない
}

1;
