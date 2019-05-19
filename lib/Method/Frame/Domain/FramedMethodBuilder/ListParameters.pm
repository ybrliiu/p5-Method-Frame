package Method::Frame::Domain::FramedMethodBuilder::ListParameters;

use Method::Frame::Base;

use Carp ();
use Type::Utils ();
use Types::Standard ();
use Role::Tiny::With qw( with );

with 'Method::Frame::Domain::FramedMethodBuilder::Parameters';

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $list) = @_;
    state $constraint = do {
        my $role_name = 'Method::Frame::Domain::FramedMethodBuilder::Parameter';
        Types::Standard::ArrayRef([ Type::Utils::role_type($role_name) ]);
    };
    Carp::croak $constraint->get_message($list) unless $constraint->check($list);

    bless +{
        list => $list,
        num  => scalar @$list,
    }, $class;
}

sub validate {
    my ($self, @args) = @_;

    my $num = $self->{num};
    return ( undef, 'Too few args' ) if scalar @args < $num;
    return ( undef, 'Too many args' ) if scalar @args > $num;

    my @meta_params = @{ $self->{list} };
    my @valid_args = map {
        my ($valid_arg, $err) = $meta_params[$_]->validate($args[$_], [ @args[0 .. $_ - 1] ]);
        if ( defined $err ) {
            return ( undef, "${_}Th $err" );
        }
        else {
            $valid_arg;
        }
    } 0 .. $num - 1;
    ( \@valid_args, undef );
}

1;
