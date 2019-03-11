package Method::Frame::Domain::FramedMethodBuilder::HashParameters;

use Method::Frame::Base;

use Carp ();
use Type::Utils ();
use Types::Standard ();
use Method::Frame::Domain::Module::Frame::HashParameters;
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
    my $args = ref $_[0] eq 'HASH' ? shift : +{@_};

    my @param_names = keys %{ $self->{hash} };
    for my $param_name (@param_names) {
        return ( undef, "Argument '$param_name' does not exists." ) 
            unless exists $args->{$param_name};
    }

    my %meta_params_map = %{ $self->{hash} };
    my @valid_args = map {
        my ($valid_arg, $err) = $meta_params_map{$_}->validate($args->{$_});
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
