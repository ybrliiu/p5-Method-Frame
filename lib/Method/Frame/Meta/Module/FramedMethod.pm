package Method::Frame::Meta::Module::FramedMethod;

use Method::Frame::Base;

use Carp ();

use parent 'Method::Frame::Meta::Module::AbstractFramedMethod';

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( code )],
);

sub new {
    my ($class, %args) = @_;
    Carp::croak "Missing argument 'code'" unless $args{code};

    my $self = $class->SUPER::new(%args);
    $self->{code} = $args{code};
    $self;
}

sub build {
    my $self = shift;
    sub {
        my $this = shift;

        my ($valid_args, $err) = $self->params->validate(@_);
        Carp::croak $err if defined $err;

        my $return_value = $self->code->($this, @$valid_args);

        if ( my $err = $self->return_type->validate($return_value) ) {
            Carp::croak qq{Method '@{[ $self->name ]}'s $err};
        }
        $return_value;
    };
}

sub to_abstract {
    my $self = shift;
    Method::Frame::Meta::Module::AbstractFramedMethod->new(
        name        => $self->name,
        params      => $self->params,
        return_type => $self->return_type,
    );
}

1;

