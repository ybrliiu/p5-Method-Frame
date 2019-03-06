package Method::Frame::Domain::ComparisonFrame::Parameters;

use Method::Frame::Base;

use Carp ();

use parent 'Method::Frame::Domain::Interfaces::Frame::Parameters';

sub _type { Carp::croak 'This is abstract method.' }

sub new { Carp::croak 'This is abstract method.' }

sub _compare_type {
    my ($self, $params) = @_;

    $self->_type eq $params->_type
        ? undef
        : 'Parameters type is different. '
            . "(@{[ $self->_type ]} parameters vs @{[ $params->_type ]} parameters)";
}

sub _compare_each_parameters { Carp::croak 'This is abstract method.' }

sub compare {
    my ($self, $params) = @_;

    if ( my $err = $self->_compare_type($params) ) {
        [ $err ];
    }
    else {
        $self->_compare_each_parameters($params);
    }
}

1;
