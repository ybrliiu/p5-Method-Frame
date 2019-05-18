package Method::Frame::Domain::ApplyRole::FramedMethod;

use Method::Frame::Base;

use Carp ();

use parent 'Method::Frame::Domain::ComparisonFrame';

sub new {
    my ($class, %args) = @_;
    Carp::croak q{Argument 'code' must be CodeRef.} if ref $args{code} ne 'CODE';

    my $self = $class->new(%args);
    $self->{code} = $args{code};
    $self;
}

sub code { shift->{code} }

1;
