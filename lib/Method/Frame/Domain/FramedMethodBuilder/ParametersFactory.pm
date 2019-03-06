package Method::Frame::Domain::FramedMethodBuilder::ParametersFactory;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util;
use Method::Frame::Domain::FramedMethodBuilder::ListParameters;
use Method::Frame::Domain::FramedMethodBuilder::HashParameters;
use Method::Frame::Domain::FramedMethodBuilder::ParameterFactory;

# alias 
use constant ParameterFactory => 'Method::Frame::Domain::FramedMethodBuilder::ParameterFactory';

sub create {
    my ($class, $args) = @_;

    if ( ref $args eq 'ARRAY' ) {
        my @args_objects = map { ParameterFactory->create($_) } @$args;
        Method::Frame::Domain::FramedMethodBuilder::ListParameters->new(\@args_objects);
    }
    elsif ( ref $args eq 'HASH' ) {
        my %args_objects = map { $_ => ParameterFactory->create($args->{$_}) } keys %$args;
        Method::Frame::Domain::FramedMethodBuilder::HashParameters->new(\%args_objects);
    }
    else {
        Carp::confess 'Invalid parameters option passed.';
    }
}

1;
