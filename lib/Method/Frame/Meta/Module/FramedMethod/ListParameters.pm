package Method::Frame::Meta::Module::FramedMethod::ListParameters;

use Method::Frame::Base;

use Carp ();

use parent 'Method::Frame::Meta::Module::FramedMethod::Parameters';

use Class::Accessor::Lite (
    ro => [qw( list )],
);

sub type { 'list' }

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $list) = @_;
    bless +{ list => $list }, $class;
}

sub num {
    my $self = shift;
    $self->{num} //= scalar @{ $self->list };
}

sub validate {
    my ($self, @args) = @_;

    return ( undef, 'Too few args' ) if scalar @args < $self->num;
    return ( undef, 'Too many args' ) if scalar @args > $self->num;

    my @valid_args = map {
        my ($meta, $param)      = ($self->list->[$_], $args[$_]);
        my ($valid_param, $err) = $meta->validate($param);
        if ( defined $err ) {
            return ( undef, "${_}Th $err" );
        }
        else {
            $valid_param;
        }
    } 0 .. $self->num - 1;
    ( \@valid_args, undef );
}

sub check_diff {
    my ($self, $parameters) = @_;
    my $errors = $self->SUPER::check_diff($parameters);
}

1;
