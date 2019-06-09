use Method::Frame::Base qw( test );

use Types::Standard qw( Int Str );
use Method::Frame::Domain::Role;
use Method::Frame::Domain::Role::FramedMethods;
use Method::Frame::Domain::Role::RequiredFramedMethods;
use Method::Frame::Domain::Role::FramedMethod;
use Method::Frame::Domain::Role::RequiredFramedMethod;
use Method::Frame::Domain::ComparisonFrame::RequiredParameter;
use Method::Frame::Domain::ComparisonFrame::DefaultParameter;
use Method::Frame::Domain::ComparisonFrame::OptionalParameter;
use Method::Frame::Domain::ComparisonFrame::ListParameters;
use Method::Frame::Domain::ComparisonFrame::HashParameters;
use Method::Frame::Domain::ComparisonFrame::ReturnType;

# alias
use constant +{
    Role                  => 'Method::Frame::Domain::Role',
    FramedMethods         => 'Method::Frame::Domain::Role::FramedMethods',
    RequiredFramedMethods => 'Method::Frame::Domain::Role::RequiredFramedMethods',
    FramedMethod          => 'Method::Frame::Domain::Role::FramedMethod',
    RequiredFramedMethod  => 'Method::Frame::Domain::Role::RequiredFramedMethod',
    RequiredParameter     => 'Method::Frame::Domain::ComparisonFrame::RequiredParameter',
    DefaultParameter      => 'Method::Frame::Domain::ComparisonFrame::DefaultParameter',
    OptionalParameter     => 'Method::Frame::Domain::ComparisonFrame::OptionalParameter',
    ListParameters        => 'Method::Frame::Domain::ComparisonFrame::ListParameters',
    HashParameters        => 'Method::Frame::Domain::ComparisonFrame::HashParameters',
    ReturnType            => 'Method::Frame::Domain::ComparisonFrame::ReturnType',
};

subtest apply => sub {
    my $meta_role  = Role->new(name => 'TestRole');
    my $applicable = Role->new(name => 'Taro');
    my $errors     = $meta_role->apply($applicable);
    is @$errors, 0;
};

subtest apply => sub {
    my $meta_role  = Role->new(
        name           => 'TestRole',
        framed_methods => FramedMethods->new([
            FramedMethod->new(
                name        => 'sum',
                params      => ListParameters->new([
                    RequiredParameter->new(Int),
                    RequiredParameter->new(Int)
                ]),
                return_type => ReturnType->new(Int),
                code        => sub { $_[0] + $_[1] },
            ),
        ]),
        required_framed_methods => RequiredFramedMethods->new([
            RequiredFramedMethod->new(
                name        => 'sum',
                params      => ListParameters->new([
                    RequiredParameter->new(Int),
                    RequiredParameter->new(Int)
                ]),
                return_type => ReturnType->new(Int),
            ),
        ]),
    );
    my $applicable = Method::Frame::Domain::Role->new(name => 'Applicable');
    is $applicable->framed_methods->num, 0;
    is $applicable->required_framed_methods->num, 0;
    my $errors = $meta_role->apply($applicable);
    is @$errors, 0;
    is $applicable->framed_methods->num, 1;
    is $applicable->required_framed_methods->num, 1;
};

done_testing();
