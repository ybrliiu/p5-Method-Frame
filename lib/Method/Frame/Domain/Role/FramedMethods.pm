package Method::Frame::Domain::Role::FramedMethods;

use Method::Frame::Base;

use Carp ();
use Type::Utils ();
use Types::Standard ();

use Class::Accessor::Lite (
    new => 0,
    ro => [qw( map )],
);

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $framed_methods) = @_;
    {
        state $constraint = do {
            my $class_name = 'Method::Frame::Domain::Role::FramedMethod';
            Types::Standard::ArrayRef([Type::Utils::class_type($class_name)]);
        };
        Carp::croak $constraint->get_message($framed_methods)
            unless $constraint->check($framed_methods);
    }

    bless +{ map => +{ map { $_->name => $_ } @$framed_methods } }, $class;
}

sub has {
    my ($self, $framed_method) = @_;
    Carp::croak 'Argument is not FrameMethod object.'
        unless $framed_method->isa('Method::Frame::Domain::ComparisonFrame');

    exists $self->map->{$framed_method->name};
}

sub maybe_get {
    my ($self, $framed_method) = @_;
    Carp::croak 'Argument is not FrameMethod object.'
        unless $framed_method->isa('Method::Frame::Domain::ComparisonFrame');

    $self->map->{$framed_method->name};
}

sub add {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $framed_method) = @_;
    Carp::croak 'Argument is not FrameMethod object.'
        unless $framed_method->isa('Method::Frame::Domain::Role::FramedMethod');

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

sub as_array_ref {
    my $self = shift;
    [ values %{ $self->map } ];
}

sub num {
    my $self = shift;
    scalar keys %{ $self->map };
}

1;

__END__
