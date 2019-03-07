package Method::Frame::Domain::Module::FramedMethod;

use Method::Frame::Base;

use Carp ();

use parent 'Method::Frame::Domain::Module::Frame';

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( code )],
);

# override
sub new {
    my ($class, %args) = @_;
    Carp::croak q{Argument 'code' is not CodeRef.} unless $args{code} ne 'CODE';

    my $self = $class->SUPER::new(%args);
    $self->{code} = $args{code};
    $self;
}

1;
