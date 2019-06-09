package Method::Frame::Domain::ApplyRole::DoesMethodInstaller::Notifier;

use Method::Frame::Base;
use Carp ();

sub new {
    my $class = shift;
    my $maybe_observer = do {
        if (@_) {
            my $observer = shift;
            Carp::croak 'Argument must be CodeRef.' if ref $observer ne 'CODE';
            $observer;
        }
        else {
            undef;
        }
    };
    bless +{ maybe_observer => $maybe_observer }, $class;
}

sub notify {
    my $self = shift;
    $self->{maybe_observer}->() if defined $self->{maybe_observer};
}

1;
