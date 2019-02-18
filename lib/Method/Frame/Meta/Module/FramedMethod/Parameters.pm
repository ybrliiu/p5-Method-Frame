package Method::Frame::Meta::Module::FramedMethod::Parameters;

use Method::Frame::Base;

use Carp ();

sub abstract_err { Carp::croak 'This is abstract method.' }

sub new { $_[0]->abstract_err }

sub validate { $_[0]->abstract_err }

sub type { Carp::croak 'This is abstract method.' }

sub check_diff {
    my ($self, $parameters) = @_;
    $self->type eq $parameters->type
        ? []
        : ['Different parameters type'];
}

1;
