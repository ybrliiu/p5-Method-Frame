package Method::Frame::Domain::Module::ParametersFactory;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util;
use Method::Frame::Domain::Module::Frame::ListParameters;
use Method::Frame::Domain::Module::Frame::HashParameters;
use Method::Frame::Domain::Module::ParameterFactory;

# alias 
use constant ParameterFactory => 'Method::Frame::Domain::Module::ParameterFactory';

sub create {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $args) = @_;

    if ( ref $args eq 'ARRAY' ) {
        my @args_objects = map { ParameterFactory->create($_) } @$args;
        Method::Frame::Domain::Module::Frame::ListParameters->new(\@args_objects);
    }
    elsif ( ref $args eq 'HASH' ) {
        my %args_objects = map { $_ => ParameterFactory->create($args->{$_}) } keys %$args;
        Method::Frame::Domain::Module::Frame::HashParameters->new(\%args_objects);
    }
    else {
        Carp::confess 'Invalid parameters option passed.';
    }
}

1;
