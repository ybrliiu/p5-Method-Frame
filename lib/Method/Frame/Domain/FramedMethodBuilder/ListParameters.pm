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
        list        => $list,
        num         => scalar(@$list),
        use_default => !!( grep { $_->isa(DefaultParameter) } @$list ),
    }, $class;
}

sub validate {
    my ($self, @args) = @_;

    my $num = $self->{num};

    return ( undef, 'Too many args' ) if @args > $num;
    return ( undef, 'Too few args' )  if @args < $num;

    my @meta_params = @{ $self->{list} };

    my @args_for_pass_default = do {
        if ($self->{use_default}) {
            map {
                !defined $args[$_] && $meta_params[$_]->isa(DefaultParameter)
                    ? $meta_params[$_]->default
                    : $args[$_]
            } 0 .. $num - 1;
        }
        else {
            @args;
        }
    };

    my @valid_args = map {
        my ($valid_arg, $err) = $meta_params[$_]->validate($args[$_], @args_for_pass_default);
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

