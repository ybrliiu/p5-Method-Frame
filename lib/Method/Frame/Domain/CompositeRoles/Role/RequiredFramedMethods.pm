package Method::Frame::Domain::CompositeRoles::Role::RequiredFramedMethods;

use Method::Frame::Base;
use Carp ();
use Type::Utils ();
use Types::Standard ();
use Method::Frame::Util qw( validate_argument_object_type );

sub new {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($class, $required_framed_methods) = @_;

    my @required_framed_methods = do {
        if ( $required_framed_methods
            ->isa('Method::Frame::Domain::Module::Role::RequiredFramedMethods') ) {
            map {
                Method::Frame::Domain::ComparisonFrame->new(
                    name        => $_->name,
                    params      => $_->params,
                    return_type => $_->return_type,
                );
            } @{ $required_framed_methods->as_array_ref };
        }
        elsif (
            (do {
                my $class_name = 'Method::Frame::Domain::ComparisonFrame';
                Types::Standard::ArrayRef([Type::Utils::class_type($class_name)]);
            })->check($required_framed_methods)
        ) {
            @$required_framed_methods;
        }
        else {
            Carp::croak 'Argument value is  invalid type.';
        }
    };

    bless [ @required_framed_methods ], $class;
}

sub composite {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $to_composite) = @_;
    validate_argument_object_type($to_composite, __PACKAGE__);

    my %id_to_frame;
    for my $frame (@$self, @$to_composite) {
        if ( exists $id_to_frame{ $frame->id } ) {
            my $errors = $id_to_frame{ $frame->id }->compare($frame);
            if (@$errors) {
                my $error_mes = 'Required method frame is different.'
                    . '(' . join(',', @$errors) . ')';
                return (undef, $error_mes);
            }
        }
        else {
            $id_to_frame{ $frame->id } = $frame;
        }
    }

    ( (ref $self)->new([ values %id_to_frame ]), undef );
}

1;
