package Method::Frame::Domain::CompositeRoles::Role::FramedMethods;

use Method::Frame::Base;
use Carp ();
use Type::Utils ();
use Types::Standard ();
use Method::Frame::Util qw( validate_argument_object_type );
use Method::Frame::Domain::ComparisonFrame;
use Method::Frame::Domain::CompositeRoles::Role::ConflictedMethods;

use constant ConflictedMethods => 'Method::Frame::Domain::CompositeRoles::Role::ConflictedMethods';

sub new {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($class, $framed_methods) = @_;

    my @framed_methods = do {
        if ( $framed_methods->isa('Method::Frame::Domain::Module::Role::FramedMethods') ) {
            map {
                Method::Frame::Domain::ComparisonFrame->new(
                    name        => $_->name,
                    params      => $_->params,
                    return_type => $_->return_type,
                );
            } @{ $framed_methods->as_array_ref };
        }
        elsif (
            (do {
                my $class_name = 'Method::Frame::Domain::ComparisonFrame';
                Types::Standard::ArrayRef([Type::Utils::class_type($class_name)]);
            })->check($framed_methods)
        ) {
            @$framed_methods;
        }
        else {
            Carp::croak 'Argument value is  invalid type.';
        }
    };

    bless [ @framed_methods ], $class;
}

sub composite {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $to_composite) = @_;
    validate_argument_object_type($to_composite, __PACKAGE__);

    my %id_to_frame;
    for my $frame (@$self, @$to_composite) {
        $id_to_frame{ $frame->id } //= [];
        push @{ $id_to_frame{ $frame->id } }, $frame;
    }

    my @conflicted_methods_sets = grep { @$_ > 1 } values %id_to_frame;
    for my $set (@conflicted_methods_sets) {
        my $before_frame = shift @$set;
        for my $frame (@$set) {
            my $errors = $before_frame->compare($frame);
            if (@$errors) {
                my $error_mes
                    = 'Method frame is different.' . '(' . join(',', @$errors) . ')';
                return (undef, undef, $error_mes);
            }
        }
    }

    my @composited_framed_methods = map { $_->[0] } grep { @$_ == 1 } values %id_to_frame;
    my @conflicted_methods        = map { $_->[0] } @conflicted_methods_sets;
    (
        (ref $self)->new(\@composited_framed_methods),
        ConflictedMethods->new(\@conflicted_methods),
        undef
    );
}

1;
