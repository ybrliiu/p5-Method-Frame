package Method::Frame::Domain::FramedMethodBuilder;

use Method::Frame::Base;

use Carp ();

sub new {
    my ($class, %args) = @_;
    for my $arg_name (qw[ name params return_type code ]) {
        Carp::croak "Missing argument '$arg_name'" unless $args{$arg_name};
    }

    Carp::croak q{Argument 'params' is not Parameters object.'}
        unless $args{params}->DOES('Method::Frame::Domain::FramedMethodBuilder::Parameters');

    Carp::croak q{Argument 'return_type' is not ReturnType object.'}
        unless $args{return_type}->DOES('Method::Frame::Domain::FramedMethodBuilder::ReturnType');

    bless +{
        name        => $args{name},
        return_type => $args{return_type},
        params      => $args{params},
        code        => $args{code},
    }, $class;
}

sub name { shift->{name} }

sub build {
    my $self = shift;
    sub {
        my $this = shift;

        my ($valid_args, $err) = $self->{params}->validate(@_);
        Carp::croak $err if defined $err;

        my $return_value = $self->{code}->($this, @$valid_args);

        if ( my $err = $self->{return_type}->validate($return_value) ) {
            Carp::croak qq{Method '$self->{name}'s $err};
        }
        $return_value;
    };
}

1;

