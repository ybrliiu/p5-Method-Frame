package Method::Frame::Domain::ApplyRole::DoesMethodInstaller;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util qw( object_isa );

sub new {
    my ($class, %args) = @_;

    bless +{
        installed             => $args{installed} // !!0,
        symbol_table_operator => do {
            my $is_symbol_table_operator = object_isa(
                $args{symbol_table_operator},
                'Method::Frame::Domain::Module::SymbolTableOperator',
            );
            Carp::croak "Argument 'symbol_table_operator' is not SymbolTableOperator object"
                unless $is_symbol_table_operator;

            $args{symbol_table_operator};
        },
    }, $class;
}

sub install {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $method_code) = @_;
    Carp::croak "Argument is not CodeRef." if ref $method_code ne 'CODE';

    return if $self->{installed};
    $self->{installed} = !!1;

    for my $method_name (qw[ does DOES ]) {
        my $maybe_code = $self->{symbol_table_operator}->maybe_get_subroutine($method_name);
        # method 'DOES' already installed by other modules
        my $install_code = do {
            if ( defined $maybe_code ) {
                sub { $maybe_code->($_[0]) || $method_code->($_[0]) };
            }
            else {
                $method_code;
            }
        };
        $self->{symbol_table_operator}->add_subroutine($method_name => $install_code);
    }
}

1;

__END__

=encoding utf9

=head1 NAME

Method::Frame::Domain::ApplyRole::DoesMethodInstaller - Role適用時に対象モジュールにインストールする does method のインストーラ

=cut
