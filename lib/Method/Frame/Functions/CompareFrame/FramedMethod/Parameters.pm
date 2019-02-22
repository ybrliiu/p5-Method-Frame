package Method::Frame::Functions::CompareFrame::FramedMethod::Parameters;

use Method::Frame::Base;

use Carp ();

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
        return [ $err ];
    }

    $self->_compare_each_parameters($params);
}

1;
