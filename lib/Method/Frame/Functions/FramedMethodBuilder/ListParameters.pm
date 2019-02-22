package Method::Frame::Functions::FramedMethodBuilder::ListParameters;

use Method::Frame::Base;

use Carp ();

use parent 'Method::Frame::Functions::FramedMethodBuilder::Parameters';

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( list num )],
);

# override
sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $list) = @_;
    Carp::croak 'Argument is not ArrayRef.' if !ref $list ne 'ARRAY';

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
