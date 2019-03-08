package Method::Frame::Domain::ComparisonFrame::HashParameters;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();
use Type::Utils ();
use Types::Standard ();
use Role::Tiny::With qw( with );

with qw( Method::Frame::Domain::ComparisonFrame::Parameters );

sub _type { 'hash' }

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $hash) = @_;
    state $constraint = do {
        my $class_name = 'Method::Frame::Domain::ComparisonFrame::Parameter';
        Types::Standard::HashRef([ Type::Utils::role_type($class_name) ]);
    };
    Carp::croak $constraint->get_message($hash) unless $constraint->check($hash);

    bless +{ hash => $hash }, $class;
}

sub hash { $_[0]->{hash} }

sub _compare_keys {
    my ($self, $params) = @_;

    my @not_exists_errors =
        map { "Parameter '$_' does not exists." }
        grep { !exists $params->{hash}->{$_} }
        sort keys %{ $self->{hash} };

    my @not_used_errors =
        map { "Compare parameter '$_' does not use." }
        grep { !exists $self->{hash}->{$_} }
        sort keys %{ $params->{hash} };

    [ @not_exists_errors, @not_used_errors ];
}

sub _compare_each_parameters {
    my ($self, $params) = @_;

    if ( my @errors = @{ $self->_compare_keys($params) } ) {
        return \@errors;
    }

    my @errors =
        map {
            my ($name, $err) = @$_;
            "Parameter '${name}' $err";
        }
        grep { defined $_->[1] }
        map {
            my $name = $_;
            my ($param, $target) = map { $_->{hash}->{$name} } $self, $params;
            [ $name, $param->compare($target) ];
        }
        sort keys %{ $self->{hash} };
    \@errors;
}

1;

