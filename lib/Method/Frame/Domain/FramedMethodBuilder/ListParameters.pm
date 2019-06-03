package Method::Frame::Domain::FramedMethodBuilder::ListParameters;

use Method::Frame::Base;

use Carp ();
use Type::Utils ();
use Types::Standard ();
use Role::Tiny::With qw( with );

# alias
use constant {
    Parameter         => 'Method::Frame::Domain::FramedMethodBuilder::Parameter',
    RequiredParameter => 'Method::Frame::Domain::FramedMethodBuilder::RequiredParameter',
    DefaultParameter  => 'Method::Frame::Domain::FramedMethodBuilder::DefaultParameter',
};

with 'Method::Frame::Domain::FramedMethodBuilder::Parameters';

sub new {
    Carp::croak 'Too few arguments' if @_ < 2;
    my ($class, $list) = @_;
    state $constraint = Types::Standard::ArrayRef([ Type::Utils::role_type(Parameter) ]);
    Carp::croak $constraint->get_message($list) unless $constraint->check($list);

    bless +{
        list                  => $list,
        num                   => scalar(@$list),
        required_params       => [ grep { $_->isa(RequiredParameter) } @$list ],
        default_param_indexes => [ grep { $list->[$_]->isa(DefaultParameter) } 0 .. $#$list ],
    }, $class;
}

sub validate {
    my ($self, @orig_args) = @_;

    my $num         = $self->{num};
    my @meta_params = @{ $self->{list} };

    return ( undef, 'Too many args' ) if @orig_args > $num;

    return ( undef, 'Too few args' ) if @orig_args < @{ $self->{required_params} };

    my @use_default_param_indexes = do {
        my $num_diff              = $num - @orig_args;
        my @default_param_indexes = @{ $self->{default_param_indexes} };
        @default_param_indexes[ $#default_param_indexes - $num_diff + 1 .. $#default_param_indexes ];
    };
    my @args = @orig_args;
    for my $i ( reverse @use_default_param_indexes ) {
        if ( $meta_params[$i]->isa(DefaultParameter) ) {
            splice @args, $_, 1, $meta_params[$i]->default() for reverse @use_default_param_indexes;
        }
        else {
            return ( undef, 'Too few args' );
        }
    }

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


__END__


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

