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
    Carp::croak 'Too many arguments' if scalar @args > $self->num;
    my @valid_data = map {
        my ($meta, $arg) = ($self->list->[$_], $args[$_]);
        $meta->validate($arg);
    } 0 .. $self->num - 1;
    Carp::croak 'Too few arguments' if scalar @valid_data < $self->num;
    return \@valid_data;
}

1;
