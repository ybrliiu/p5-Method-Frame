package Method::Frame::Functions::Role;

use Method::Frame::Base;

use Carp ();
use Method::Frame::Util;
use Method::Frame::Functions::Role::FramedMethods;
use Method::Frame::Functions::Role::RequiredFramedMethods;

use parent 'Method::Frame::Functions::Role::Applicable';

use Class::Accessor::Lite (
    new => 0,
    ro => [qw( name framed_methods required_framed_methods )]
);

sub new {
    my ($class, %args) = @_;

    Carp::croak "Missing argument 'name'" unless $args{name};

    my $framed_methods = do {
        if ( exists $args{framed_methods} ) {
            my $is_framed_methods = Method::Frame::Util::object_isa(
                $args{framed_methods},
                'Method::Frame::Functions::Role::FramedMethods'
            );
            $is_framed_methods
                ? $args{framed_methods}
                : Carp::croak q{Argument 'framed_methods' is not FramedMethods object.};
        }
        else {
            Method::Frame::Functions::Role::FramedMethods->new([]);
        }
    };

    my $required_framed_methods = do {
        if ( exists $args{required_framed_methods} ) {
            my $is_required_framed_methods = Method::Frame::Util::object_isa(
                $args{required_framed_methods},
                'Method::Frame::Functions::Role::RequiredFramedMethods'
            );
            $is_required_framed_methods
                ? $args{required_framed_methods}
                : Carp::croak q{Argument 'required_framed_methods' is not RequiredFramedMethods object.};
        }
        else {
            Method::Frame::Functions::Role::RequiredFramedMethods->new([]);
        }
    };

    bless +{
        name                    => $args{name},
        framed_methods          => $framed_methods,
        required_framed_methods => $required_framed_methods,
    }, $class;
}

# override
sub consume_required_framed_methods {
    my ($self, $required_framed_methods) = @_;

    my $apply_errors = $self->required_framed_methods->apply($required_framed_methods);

    my (undef, $implemented_errors) =
        $self->are_required_framed_methods_implemented($self->required_framed_methods);

    [ @$apply_errors, @$implemented_errors ];
}

sub are_required_framed_methods_implemented {
    my ($self, $required_framed_methods) = @_;
    # 同じ名前のFrameがあったら等しいFrameかどうかをチェックする
    my ($are_implemented, $errors) =
        $required_framed_methods->are_implemented($self->framed_methods);
    ($are_implemented, $errors);
}

# override
sub consume_framed_methods {
    my ($self, $framed_methods) = @_;
    my ($collision_framed_methods, $apply_errors) = $self->framed_methods->apply($framed_methods);

    if ( @$apply_errors > 0 ) {
        return $apply_errors;
    }

    my @errors = do {
        if ( @$collision_framed_methods > 0 ) {
            my @required_framed_methods =
                map { $_->as_required_framed_method() } @$collision_framed_methods;
            my @add_errors =
                grep { defined $_ }
                map { $self->required_framed_methods->add($_) }
                @required_framed_methods;
        }
        else {
            ();
        }
    };

    \@errors;
}

sub apply {
    Carp::croak 'Too few argument' if @_ < 2;
    my ($self, $applicable) = @_;
    Carp::croak 'Argument is not applicable Object.'
        unless $applicable->isa('Method::Frame::Functions::Role::Applicable');

    my @errors =
        map { @$_ }
        (
            $applicable->consume_framed_methods($self->framed_methods),
            $applicable->consume_required_framed_methods($self->required_framed_methods),
        );
    \@errors;
}

1;

__END__

=encoding utf8

=head1 NAME

Method::Frame::Functions::Role - FramedMethod Role class

=head1 METHODS

=head2 apply_to_class

- RoleのClassへの適用
  - RoleのRequiredFramedMethodsとClassのFramedMethodsを比較
    - 実装されていないRequiredFramedMethodがあればエラー
    - 異なるFramedMethodがあればエラー
  - RoleのFramedMethodsをClassのFramedMethodsに追加
    - 同じ名前のFramedMethodがあればエラーとなる
  - RequiredFramedMethodsが全て実装されているかどうかチェック

=head2 apply_to_role

- RoleのRoleへの適用
  - RoleのFramedMethodsをRoleのFramedMethodsに追加
    - 同じ名前のFramedMethodがあれば適用される側のRoleのRequiredFramedMethodsに追加する
  - RoleのRequiredFramedMethodsをRoleのRequiredFramedMethodsに追加
    - 異なるFramedMethodがあればエラー
  - Req

=cut
