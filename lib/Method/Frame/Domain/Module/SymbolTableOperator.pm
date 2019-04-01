package Method::Frame::Domain::Module::SymbolTableOperator;

use Method::Frame::Base;

use Carp ();
use Package::Stash;

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $package_name) = @_;

    bless +{ package_name => $package_name }, $class;
}

sub has_subroutine {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($self, $name) = @_;

    no strict 'refs'; ## no critic
    defined *{"$self->{package_name}::${name}"}{CODE};
}

sub add_subroutine {
    Carp::croak 'Too few arguments' if @_ < 3;
    my ($self, $name, $code) = @_;
    Carp::croak 'Parameter is not CodeRef' unless ref $code eq 'CODE';

    if ( $self->has_subroutine($name) ) {
        "Subroutine '${name}' is already exists.";
    }
    else {
        no strict 'refs'; ## no critic
        *{"$self->{package_name}::${name}"} = $code;
        undef;
    }
}

sub remove_subroutine {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($self, $name) = @_;

    if ( $self->has_subroutine($name) ) {
        my $stash = Package::Stash->new($self->{package_name});
        $stash->remove_symbol("&${name}");
        undef;
    }
    else {
        "Subroutine '${name}' does not exists.";
    }
}

1;
