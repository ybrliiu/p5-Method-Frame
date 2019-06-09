package Method::Frame::Domain::ApplyRole::Class;

use Method::Frame::Base;
use Role::Tiny::With qw( with );
use Class::Method::Modifiers qw( around );
use Method::Frame::Util;

with 'Method::Frame::Domain::ApplyRole::Applicable';

around new => sub {
    my ($orig, $class, %args) = @_;

    Carp::croak "Argument 'name' is required." unless exists $args{name};

    Method::Frame::Util::validate_argument_object_type(
        framed_methods => $args{framed_methods},
        'Method::Frame::Domain::ApplyRole::Role::FramedMethods',
    );

    Method::Frame::Util::validate_argument_object_type(
        required_framed_methods => $args{required_framed_methods},
        'Method::Frame::Functions::Role::RequiredFramedMethods'
    );

    my $self = $class->$orig(%args);
    $self->{$_} = $args{$_} for qw( name framed_methods required_framed_methods );
    $self;
};

sub consume {
    Carp::croak 'Too few arguments.' if @_ < 3;
    my ($self, $name, $framed_methods, $required_framed_methods) = @_;

    my @errors =
        map { @$_ }
        (
            $self->consume_framed_methods($framed_methods),
            $self->consume_required_framed_methods($required_framed_methods),
        );

    if ( @errors == 0 ) {
        $self->add_consumed_role_name($self->name);
        $self->install_does();
    }

    \@errors;
}

sub is_name_equals {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $role_name) = @_;
    $self->{name} eq $role_name;
}

sub consume_framed_methods {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $framed_methods) = @_;

    # collision methods の errors もこっちであげてくれー
    my $apply_errors = $self->{framed_methods}->consume($framed_methods);
    return $apply_errors if @$apply_errors > 0;

    my @errors =
        grep { defined $_ }
        map { $self->{symbol_table_operator}->add_subroutine($_->code) }
        @{ $self->{framed_methods} };

    \@errors;
}

sub consume_required_framed_methods {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($self, $required_framed_methods) = @_;

    my ($are_implemented, $implemented_errors) =
        $self->are_required_framed_methods_implemented($required_framed_methods);

    [
        ( $are_implemented ? () : 'Required framed methods are not implemented.' ),
        @$implemented_errors
    ];
}

1;

__END__

- RoleのClassへの適用
  - RoleのFramedMethodsをClassのFramedMethodsに追加
    - 同じ名前のFramedMethodがあればエラーとなる
    - メソッド名の衝突があればエラー
  - RoleのRequiredFramedMethodsとClassのFramedMethodsを比較
    - 実装されていないRequiredFramedMethodがあればエラー
    - 異なるFramedMethodがあればエラー
  - RequiredFramedMethodsが全て実装されているかどうかチェック

