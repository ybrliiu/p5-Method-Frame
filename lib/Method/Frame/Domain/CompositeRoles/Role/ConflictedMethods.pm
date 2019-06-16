package Method::Frame::Domain::CompositeRoles::Role::ConflictedMethods;

use Method::Frame::Base;
use Carp ();
use Type::Utils ();
use Types::Standard ();
use Method::Frame::Util qw( validate_argument_object_type );

sub new {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($class, $framed_methods) = @_;
    state $constraint = do {
        my $class_name = 'Method::Frame::Domain::ComparisonFrame';
        Types::Standard::ArrayRef([Type::Utils::class_type($class_name)]);
    };
    Carp::croak $constraint->get_message unless $constraint->check($framed_methods);

    bless [ @$framed_methods ], $class;
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
                my $error_mes = 'Conflicted method frame is different.'
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
