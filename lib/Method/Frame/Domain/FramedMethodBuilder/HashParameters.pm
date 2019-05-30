package Method::Frame::Domain::FramedMethodBuilder::HashParameters;

use Method::Frame::Base;

use Carp ();
use Type::Utils ();
use Types::Standard ();
use Role::Tiny::With qw( with );

with 'Method::Frame::Domain::FramedMethodBuilder::Parameters';

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $hash) = @_;
    state $constraint = do {
        my $role_name = 'Method::Frame::Domain::FramedMethodBuilder::Parameter';
        Types::Standard::HashRef([ Type::Utils::role_type($role_name) ]);
    };
    Carp::croak $constraint->get_message($hash) unless $constraint->check($hash);

    bless +{ hash => $hash }, $class;
}

sub validate {
    my $self = shift;
    my $orig_args = ref $_[0] eq 'HASH' ? shift : +{@_};

    my @param_names = keys %{ $self->{hash} };

    my %args = map {
        my $param_name = $_;
        if ( exists $orig_args->{$param_name} ) {
            $param_name => $orig_args->{$param_name};
        }
        else {
            if ( $self->{hash}{$param_name}
                ->isa('Method::Frame::Domain::FramedMethodBuilder::DefaultParameter')
            ) {
                $param_name => $self->{hash}{$param_name}{default};
            }
            else {
                return (undef, "Argument '$param_name' does not exists.")
                    unless exists $orig_args->{$param_name};
            }
        }
    } @param_names;

    my %meta_params_map = %{ $self->{hash} };
    my @valid_args = map {
        my ($valid_arg, $err) = $meta_params_map{$_}->validate($args{$_}, \%args);
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
