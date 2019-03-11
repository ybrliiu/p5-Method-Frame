package Method::Frame::Domain::Module::Frame::DefaultParameter;

use Method::Frame::Base;

use Class::Accessor::Lite (
    new => 1,
    ro  => [qw( default )],
);

use Carp ();
use Role::Tiny::With qw( with );
use Class::Method::Modifiers qw( around );
use Method::Frame::Domain::FramedMethodBuilder::DefaultParameter;

with 'Method::Frame::Domain::Module::Frame::Parameter';

around new => sub {
    my ($orig, $class, $constraint, $default) = @_;

    my $self = $class->$orig($constraint);
    $self->{default} = $default;
    $self;
};

sub as_framed_method_builder {
    my $self = shift;
    Method::Frame::Domain::FramedMethodBuilder::DefaultParameter->new(
        $self->{constraint},
        $self->{default},
    );
}

1;
