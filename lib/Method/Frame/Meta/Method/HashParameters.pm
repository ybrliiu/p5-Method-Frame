package Method::Frame::Meta::Method::HashParameters;

use Method::Frame::Base;

use Carp ();

use parent 'Method::Frame::Meta::Method::Parameters';

use Class::Accessor::Lite (
    ro => [qw( hash )],
);

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $hash) = @_;
    bless +{ hash => $hash }, $class;
}

sub validate {
    my $self = shift;
    my $args = ref $_[0] eq 'HASH' ? shift : +{@_};

    my @param_names = keys %{ $self->hash };
    for my $param_name (@param_names) {
        return ( undef, "Argument '$param_name' does not exists." ) 
            unless exists $args->{$param_name};
    }

    my @valid_args = map {
        my ($param, $argument)     = ($self->hash->{$_}, $args->{$_});
        my ($valid_argument, $err) = $param->validate($argument);
        if ( defined $err ) {
            return ( undef, "Argument '$_' $err" );
        }
        else {
            ( $_ => $valid_argument );
        }
    } @param_names;
    ( \@valid_args, undef );
}

1;
