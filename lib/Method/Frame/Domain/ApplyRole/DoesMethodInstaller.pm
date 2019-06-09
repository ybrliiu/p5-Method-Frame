package Method::Frame::Domain::ApplyRole::DoesMethodInstaller;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util;

use Method::Frame::Domain::ApplyRole::DoesMethodInstaller::Notifier;

sub new {
    my ($class, %args) = @_;

    Carp::croak q{Argument 'installed' is required.} unless exists $args{installed};

    Method::Frame::Util::validate_argument_object_type(
        symbol_table_operator => $args{symbol_table_operator},
        'Method::Frame::Domain::Module::SymbolTableOperator',
    );

    Method::Frame::Util::validate_argument_object_type(
        notifier => $args{notifier},
        'Method::Frame::Domain::ApplyRole::DoesMethodInstaller::Notifier',
    );

    bless +{
        installed             => !!$args{installed},
        notifier              => $args{notifier},
        symbol_table_operator => $args{symbol_table_operator},
    }, $class;
}

sub install {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $method_code) = @_;
    Carp::croak 'Argument is not CodeRef.' if ref $method_code ne 'CODE';

    return if $self->{installed};

    for my $method_name (qw[ does DOES ]) {
        my $maybe_code = $self->{symbol_table_operator}->maybe_get_subroutine($method_name);
        my $install_code = do {
            if ( defined $maybe_code ) {
                # method 'DOES' already installed by other modules
                sub { $maybe_code->($_[0]) || $method_code->($_[0]) };
            }
            else {
                $method_code;
            }
        };
        $self->{symbol_table_operator}->add_subroutine($method_name => $install_code);
    }

    $self->{installed} = !!1;
    $self->{notifier}->notify();
}

1;

__END__

=encoding utf9

=head1 NAME

Method::Frame::Domain::ApplyRole::DoesMethodInstaller - Role適用時に対象モジュールにインストールする does method のインストーラ

=cut
