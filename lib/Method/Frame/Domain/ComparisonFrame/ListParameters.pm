package Method::Frame::Domain::ComparisonFrame::ListParameters;

use Method::Frame::Base;

use Carp ();
use Scalar::Util ();
use Type::Utils ();
use Types::Standard ();
use Role::Tiny::With qw( with );

with qw( Method::Frame::Domain::ComparisonFrame::Parameters );

sub _type { 'list' }

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $list) = @_;
    state $constraint = do {
        my $class_name = 'Method::Frame::Domain::ComparisonFrame::Parameter';
        Types::Standard::ArrayRef([ Type::Utils::role_type($class_name) ]);
    };
    Carp::croak $constraint->get_message($list) unless $constraint->check($list);

    bless +{
        list => $list,
        num  => scalar @$list,
    }, $class;
}

sub _compare_num {
    my ($self, $params) = @_;

    $self->{num} == $params->{num}
        ? undef
        : qq{Number of Parameters is different. ($self->{num} vs $params->{num})};
}

sub _compare_each_parameters {
    my ($self, $params) = @_;

    if ( my $err = $self->_compare_num($params) ) {
        return [ $err ];
    }

    my @errors =
        map {
            my ($i, $err) = @$_;
            "${i}Th parameter $err";
        }
        grep { defined $_->[1] }
        map {
            my ($i, $param, $target) = @$_;
            [ $i, $param->compare($target) ];
        }
        map { [ $_, $self->{list}->[$_], $params->{list}->[$_] ] }
        0 .. $self->{num} - 1;
    \@errors;
}

1;
