package Method::Frame::Domain::ApplyRole::AddedConsumedRoleNameNotifier;

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
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($self, $added_consumed_role_name) = @_;
    $self->{maybe_observer}->($added_consumed_role_name) if defined $self->{maybe_observer};
}

1;
