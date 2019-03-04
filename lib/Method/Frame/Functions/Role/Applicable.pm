package Method::Frame::Functions::Role::Applicable;

use Method::Frame::Base;

use Carp ();

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( consumed_role_names symbol_table_operator )],
);

sub add_consumed_role_name { Carp::croak 'This is abstract method.' }

sub install_does {
    my $self = shift;

    my $does_code = sub { $self->consumed_role_names->has($_[0]) };
    for my $method_name (qw[ does DOES ]) {
        my $maybe_code = $self->symbol_table_operator->maybe_get_subroutine($method_name);
        # method 'DOES' already installed by other modules
        my $install_code = do {
            if ( defined $maybe_code ) {
                sub { $maybe_code->($_[0]) || $does_code->($_[0]) };
            }
            else {
                $does_code;
            }
        };
        $self->symbol_table_operator->add_subroutine($method_name => $install_code);
    }
}

sub consume_required_framed_methods { Carp::croak 'This is abstract method.' }

sub are_required_framed_methods_implemented {
    my ($self, $required_framed_methods) = @_;
    my ($are_implemented, $errors) =
        $required_framed_methods->are_implemented($self->framed_methods);
    ($are_implemented, $errors);
}

sub consume_framed_methods { Carp::croak 'This is abstract method.' }

1;
