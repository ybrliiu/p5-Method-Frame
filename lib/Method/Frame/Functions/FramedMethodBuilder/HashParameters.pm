package Method::Frame::Functions::FramedMethodBuilder::HashParameters;

use Method::Frame::Base;

use Carp ();
use Type::Utils ();
use Types::Standard ();

use parent qw(
    Method::Frame::Functions::FramedMethodBuilder::Parameters
    Method::Frame::Functions::Interfaces::Frame::HashParameters
);

# override
sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $hash) = @_;
    {
        state $constraint = do {
            my $class_name = 'Method::Frame::Functions::FramedMethodBuilder::Parameter';
            Types::Standard::HashRef([ Type::Utils::class_type($class_name) ]);
        };
        Carp::croak $constraint->get_message($hash) unless $constraint->check($hash);
    }

    bless +{ hash => $hash }, $class;
}

# override
sub validate {
    my $self = shift;
    my $args = ref $_[0] eq 'HASH' ? shift : +{@_};

    my @param_names = keys %{ $self->hash };
    for my $param_name (@param_names) {
        return ( undef, "Argument '$param_name' does not exists." ) 
            unless exists $args->{$param_name};
    }

    my %meta_params_map = %{ $self->hash };
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
