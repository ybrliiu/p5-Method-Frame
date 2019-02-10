package Mule::Meta::Method::ListArguments;
use strict;
use warnings;
use utf8;
use Carp ();

use parent 'Mule::Meta::Method::Arguments';

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

    return ( undef, 'Too many arguments' ) if scalar @args > $self->num;

    my @valid_args = map {
        my ($meta, $arg)       = ($self->list->[$_], $args[$_]);
        my ($valid_data, $err) = $meta->validate($arg);
        if ( defined $err ) {
            return ( undef, "${_}Th $err" );
        }
        else {
            $valid_data;
        }
    } 0 .. $self->num - 1;

    return ( undef, 'Too few arguments' ) if scalar @valid_args < $self->num;

    return ( \@valid_args, undef );
}

1;
