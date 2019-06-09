package Method::Frame::Domain::FramedMethodBuilder::HashParameters;

use Method::Frame::Base;

use Carp ();
use Type::Utils ();
use Types::Standard ();
use Role::Tiny::With qw( with );

# alias
use constant {
    Parameter        => 'Method::Frame::Domain::FramedMethodBuilder::Parameter',
    DefaultParameter => 'Method::Frame::Domain::FramedMethodBuilder::DefaultParameter',
};

with 'Method::Frame::Domain::FramedMethodBuilder::Parameters';

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $hash) = @_;
    state $constraint = Types::Standard::HashRef([ Type::Utils::role_type(Parameter) ]);
    Carp::croak $constraint->get_message($hash) unless $constraint->check($hash);

    bless +{ hash => $hash }, $class;
}

sub validate {
    my $self = shift;
    my $args = ref $_[0] eq 'HASH' ? shift : +{@_};

    my @param_names = keys %{ $self->{hash} };

    my %args_for_pass_default = map {
        my $param_name = $_;
        if ( exists $args->{$param_name} ) {
            $param_name => $self->{hash}{$param_name}->isa(DefaultParameter)
                ? $self->{hash}{$param_name}->default()
                : $args->{$param_name};
        }
        else {
            if ( $self->{hash}{$param_name}->isa(DefaultParameter) ) {
                $param_name => $self->{hash}{$param_name}->default();
            }
            else {
                return ( undef, "Argument '$param_name' does not exists." );
            }
        }
    } @param_names;

    for my $arg_name (keys %$args) {
        return ( undef, "Parameter '$arg_name' does not exists." )
            unless exists $self->{hash}{$arg_name};
    }

    my %meta_params_map = %{ $self->{hash} };
    my @valid_args = map {
        my ($valid_arg, $err) = $meta_params_map{$_}->validate($args->{$_}, %args_for_pass_default);
        if ( defined $err ) {
            return ( undef, "Argument '$_' $err" );
        }
        else {
            ( $_ => $valid_arg );
        }
    } @param_names;

    ( \@valid_args, undef );
}

1;
