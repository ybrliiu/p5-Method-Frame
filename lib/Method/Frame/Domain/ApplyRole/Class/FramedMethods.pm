package Method::Frame::Domain::ApplyRole::Class::FramedMethods;

use Method::Frame::Base;

use Carp ();
use Type::Utils ();
use Types::Standard ();
use Method::Frame::Util;

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $framed_methods) = @_;
    {
        state $constraint = do {
            my $class_name = 'Method::Frame::Domain::ApplyRole::FramedMethod';
            Types::Standard::ArrayRef([Type::Utils::class_type($class_name)]);
        };
        Carp::croak $constraint->get_message($framed_methods)
            unless $constraint->check($framed_methods);
    }

    bless +{ map => +{ map { $_->id => $_ } @$framed_methods } }, $class;
}

sub has {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $framed_method) = @_;
    Method::Frame::Util::validate_argument_object_type(
        $framed_method, 
        'Method::Frame::Domain::ApplyRole::FramedMethod'
    );

    exists $self->map->{$framed_method->name};
}

sub maybe_get {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $framed_method) = @_;
    Method::Frame::Util::validate_argument_object_type(
        $framed_method, 
        'Method::Frame::Domain::ApplyRole::FramedMethod'
    );

    $self->map->{$framed_method->name};
}

sub add {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $framed_method) = @_;
    Method::Frame::Util::validate_argument_object_type(
        $framed_method, 
        'Method::Frame::Domain::ApplyRole::FramedMethod'
    );

    if ( $self->has($framed_method) ) {
        "Framed method '@{[ $framed_method->name ]}' is already exists.";
    }
    else {
        $self->map->{$framed_method->name} = $framed_method;
        undef;
    }
}

sub apply {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $framed_methods) = @_;
    Method::Frame::Util::validate_argument_object_type(
        $framed_methods, 
        'Method::Frame::Domain::Role::FramedMethods'
    );

    my @collision_framed_methods = grep { $self->has($_) } @{ $framed_methods->as_array_ref };

    # 同名で異なる FrameMethod があった場合, そもそも合成できないのでエラーになる
    my @compare_errors = map {
        my $collision_framed_method = $_;
        my $self_framed_method      = $self->maybe_get($collision_framed_method);
        my $errors                  = $self_framed_method->compare($collision_framed_method);
        @$errors;
    } @collision_framed_methods;

    my @errors = do {
        # エラーがなかったら衝突していないメソッドを追加
        if ( @compare_errors == 0 ) {
            my @add_framed_methods = grep { !$self->has($_) } @{ $framed_methods->as_array_ref };
            my @add_errors         = grep { defined $_ } map { $self->add($_) } @add_framed_methods;
        }
        else {
            @compare_errors;
        }
    };

    (\@collision_framed_methods, \@errors);
}

sub num {
    my $self = shift;
    scalar keys %{ $self->map };
}

1;



1;
