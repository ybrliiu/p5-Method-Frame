package Method::Frame::Functions::SymbolTableOperator;

use Method::Frame::Base;

use Carp ();

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( package_name )],
);

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $package_name) = @_;

    bless +{package_name => $package_name}, $class;
}

sub has_subroutine {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($self, $name) = @_;

    no strict 'refs'; ## no critic
    defined *{ $self->package_name . '::' . $name }{CODE};
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
        *{$self->package_name . '::' . $name} = $code;
        undef;
    }
}

1;
