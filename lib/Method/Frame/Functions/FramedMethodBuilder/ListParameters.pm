package Method::Frame::Functions::FramedMethodBuilder::ListParameters;

use Method::Frame::Base;

use Carp ();
use Type::Utils ();
use Types::Standard ();

use parent qw(
    Method::Frame::Functions::FramedMethodBuilder::Parameters
    Method::Frame::Functions::Interfaces::Frame::ListParameters
);

# override
sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $list) = @_;
    {
        state $constraint = do {
            my $class_name = 'Method::Frame::Functions::FramedMethodBuilder::Parameter';
            Types::Standard::ArrayRef([ Type::Utils::class_type($class_name) ]);
        };
        Carp::croak $constraint->get_message($list) unless $constraint->check($list);
    }

    bless +{
        list => $list,
        num  => scalar @$list,
    }, $class;
}

# override
sub validate {
    my ($self, @args) = @_;

    my $num = $self->num;
    return ( undef, 'Too few args' ) if scalar @args < $num;
    return ( undef, 'Too many args' ) if scalar @args > $num;

    my @meta_params = @{ $self->list };
    my @valid_args = map {
        my ($valid_arg, $err) = $meta_params[$_]->validate($args[$_]);
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
