package Method::Frame::Domain::Module::Frame::ListParameters;

use Method::Frame::Base;

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( list num )],
);

use Carp ();
use Role::Tiny::With qw( with );
use Method::Frame::Domain::FramedMethodBuilder::ListParameters;

with 'Method::Frame::Domain::Module::Frame::Parameters';

sub new {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($class, $list) = @_;

    bless +{
        list => $list,
        num  => scalar @$list,
    }, $class;
}

sub as_framed_method_builder {
    my $self = shift;
    my @list = map { $_->as_framed_method_builder() } @{ $self->{list} };
    Method::Frame::Domain::FramedMethodBuilder::ListParameters->new(\@list);
}

1;
