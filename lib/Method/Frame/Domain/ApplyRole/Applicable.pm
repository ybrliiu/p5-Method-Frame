package Method::Frame::Domain::ApplyRole::Applicable;

use Method::Frame::Base;
use Role::Tiny;

use Method::Frame::Util;

requires 'add_consumed_role_names';

requires 'consume_framed_methods';

requires 'consume_required_framed_methods';

sub new {
    my ($class, %args) = @_;

    Method::Frame::Util::validate_argument_object_type(
        consumed_role_names => $args{consumed_role_names},
        'Method::Frame::Domain::ApplyRole::ConsumedRoleNames',
    );

    Method::Frame::Util::validate_argument_object_type(
        does_method_installer => $args{does_method_installer},
        'Method::Frame::Domain::ApplyRole::DoesMethodInstaller',
    );

    bless +{
        consumed_role_names   => $args{consumed_role_names},
        does_method_installer => $args{does_method_installer},
    }, $class;
}

sub are_required_framed_methods_implemented {
    my ($self, $required_framed_methods) = @_;
    my ($are_implemented, $errors) =
        $required_framed_methods->are_implemented($self->framed_methods);
    ($are_implemented, $errors);
}

sub install_does_method {
    my $self = shift;
    $self->{does_method_installer}->install(sub { $self->{consumed_role_names}->has($_[0]) });
}

1;

__END__

=encoding utf8

=head1 NAME

Method::Frame::Domain::ApplyRole::Applicable - Role適用処理の適用対象のインターフェース

=cut
