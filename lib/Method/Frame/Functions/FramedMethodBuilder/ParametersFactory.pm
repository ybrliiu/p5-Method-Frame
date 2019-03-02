package Method::Frame::Functions::FramedMethodBuilder::ParametersFactory;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util;
use Method::Frame::Functions::FramedMethodBuilder::ListParameters;
use Method::Frame::Functions::FramedMethodBuilder::HashParameters;
use Method::Frame::Functions::FramedMethodBuilder::ParameterFactory;

# alias 
use constant ParameterFactory => 'Method::Frame::Functions::FramedMethodBuilder::ParameterFactory';

sub create {
    my ($class, $args) = @_;

    if ( ref $args eq 'ARRAY' ) {
        my @args_objects = map { ParameterFactory->create($_) } @$args;
        Method::Frame::Functions::FramedMethodBuilder::ListParameters->new(\@args_objects);
    }
    elsif ( ref $args eq 'HASH' ) {
        my %args_objects = map { $_ => ParameterFactory->create($args->{$_}) } keys %$args;
        Method::Frame::Functions::FramedMethodBuilder::HashParameters->new(\%args_objects);
    }
    else {
        Carp::confess 'Invalid parameters option passed.';
    }
}

1;
