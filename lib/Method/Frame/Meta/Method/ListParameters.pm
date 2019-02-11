package Method::Frame::Meta::Method::ListParameters;
use strict;
use warnings;
use utf8;
use Carp ();

use parent 'Method::Frame::Meta::Method::Parameters';

use Class::Accessor::Lite (
    ro => [qw( list )],
);

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $list) = @_;
    bless +{ list => $list }, $class;
}

sub num {
    my $self = shift;
    $self->{num} //= scalar @{ $self->list };
}

sub validate {
    my ($self, @args) = @_;

    return ( undef, 'Too few args' ) if scalar @args < $self->num;
    return ( undef, 'Too many args' ) if scalar @args > $self->num;

    my @valid_args = map {
        my ($meta, $param)      = ($self->list->[$_], $args[$_]);
        my ($valid_param, $err) = $meta->validate($param);
        if ( defined $err ) {
            return ( undef, "${_}Th $err" );
        }
        else {
            $valid_param;
        }
    } 0 .. $self->num - 1;
    ( \@valid_args, undef );
}

1;