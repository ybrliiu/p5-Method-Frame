package Method::Frame::Domain::ComparisonFrame;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();
use Method::Frame::Util;

sub new {
    my ($class, %args) = @_;

    for my $arg_name (qw[ name params return_type ]) {
        Carp::croak "Missing argument '$arg_name'" unless exists $args{$arg_name};
    }

    Carp::croak q{Argument 'params' is not Parameters object.'}
        unless $args{params}->DOES('Method::Frame::Domain::ComparisonFrame::Parameters');

    Carp::croak q{Argument 'return_type' is not ReturnType object.'}
        unless $args{return_type}->isa('Method::Frame::Domain::ComparisonFrame::ReturnType');

    bless +{
        name        => $args{name},
        params      => $args{params},
        return_type => $args{return_type},
    }, $class;
}

sub compare {
    my ($self, $frame) = @_;

    if ( $self->{name} ne $frame->{name} ) {
        [ "Frame name is different. ($self->{name} vs $frame->{name})" ];
    }
    else {
        [
            @{ $self->{params}->compare( $frame->{params} ) },
            @{ $self->{return_type}->compare( $frame->{return_type} ) },
        ]
    }
}

1;
