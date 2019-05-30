package Method::Frame::Domain::FramedMethodBuilder::ListParameters;

use Method::Frame::Base;

use Carp ();
use Type::Utils ();
use Types::Standard ();
use Role::Tiny::With qw( with );

with 'Method::Frame::Domain::FramedMethodBuilder::Parameters';

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $list) = @_;
    state $constraint = do {
        my $role_name = 'Method::Frame::Domain::FramedMethodBuilder::Parameter';
        Types::Standard::ArrayRef([ Type::Utils::role_type($role_name) ]);
    };
    Carp::croak $constraint->get_message($list) unless $constraint->check($list);

    bless +{
        list => $list,
        num  => scalar @$list,
    }, $class;
}

sub validate {
    my ($self, @orig_args) = @_;

    my $num = $self->{num};

    # 仮実装
    # r, r, d1, d2
    # (1, 1, 1) = (1, 1, 1, d2)
    # (1, 1)    = (1, 1, d1, d2)
    # r, d1, r, d2
    # (1, 1, 1) = (1, 1, 1, d2)
    # (1, 1)    = (1, d1, 1, d2)
    # d1, r, d2, r
    # (1, 1, 1) = (1, 1, d2, 1)
    # (1, 1)    = (d1, 1, d2, 1)
    # d1, r, d2, r, d3
    # (1, 1, 1, 1) = (1, 1, 1, 1, d3)
    # (1, 1, 1)    = (1, 1, d2, 1, d3)
    # (1, 1)       = (d1, 1, d2, 1, d3)
    # デフォルト引数の位置を記録
    # デフォルト引数のリストを後方から順番に埋める

    return ( undef, 'Too many args' ) if @orig_args > $num;

    my $required_params = $self->{required_params} //= do {
        my @required_params =
            grep { $_->isa('Method::Frame::Domain::FramedMethodBuilder::RequiredParameter') }
            @{ $self->{list} };
        \@required_params;
    };

    return ( undef, 'Too few args' ) if @orig_args < @$required_params;

    my $default_param_indexes = $self->{default_param_indexes} //= do {
        my @default_param_indexes =
            grep { $self->{list}[$_]->isa('Method::Frame::Domain::FramedMethodBuilder::DefaultParameter') }
            0 .. $#{ $self->{list} };
        \@default_param_indexes;
    };

    my $num_diff = @{ $self->{list} } - @orig_args;

    my @use_default_param_indexes =
        @$default_param_indexes[ $#$default_param_indexes - $num_diff + 1 .. $#$default_param_indexes ];

    my @args;
    $args[$_] = $self->{list}[$_]{default} for reverse @use_default_param_indexes;
    for my $i (0 .. $#{ $self->{list} } - $num_diff) {
      $args[$i] = shift @orig_args unless defined $args[$i];
    }

    my @meta_params = @{ $self->{list} };
    my @valid_args = map {
        my ($valid_arg, $err) = $meta_params[$_]->validate($args[$_], \@args);
        if ( defined $err ) {
            return ( undef, "${_}Th $err" );
        }
        else {
            $valid_arg;
        }
    } 0 .. $num - 1;
    ( \@valid_args, undef );
}

1;
