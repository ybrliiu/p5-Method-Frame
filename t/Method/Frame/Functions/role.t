use Method::Frame::Base qw( test );

use Types::Standard qw( Int Str );
use Method::Frame::Functions::Role;
use Method::Frame::Functions::Role::FramedMethods;
use Method::Frame::Functions::Role::RequiredFramedMethods;
use Method::Frame::Functions::Role::FramedMethod;
use Method::Frame::Functions::Role::RequiredFramedMethod;
use Method::Frame::Functions::ComparisonFrame::RequiredParameter;
use Method::Frame::Functions::ComparisonFrame::DefaultParameter;
use Method::Frame::Functions::ComparisonFrame::OptionalParameter;
use Method::Frame::Functions::ComparisonFrame::ListParameters;
use Method::Frame::Functions::ComparisonFrame::HashParameters;
use Method::Frame::Functions::ComparisonFrame::ReturnType;

# alias
use constant +{
    Role                  => 'Method::Frame::Functions::Role',
    FramedMethods         => 'Method::Frame::Functions::Role::FramedMethods',
    RequiredFramedMethods => 'Method::Frame::Functions::Role::RequiredFramedMethods',
    FramedMethod          => 'Method::Frame::Functions::Role::FramedMethod',
    RequiredFramedMethod  => 'Method::Frame::Functions::Role::RequiredFramedMethod',
    RequiredParameter     => 'Method::Frame::Functions::ComparisonFrame::RequiredParameter',
    DefaultParameter      => 'Method::Frame::Functions::ComparisonFrame::DefaultParameter',
    OptionalParameter     => 'Method::Frame::Functions::ComparisonFrame::OptionalParameter',
    ListParameters        => 'Method::Frame::Functions::ComparisonFrame::ListParameters',
    HashParameters        => 'Method::Frame::Functions::ComparisonFrame::HashParameters',
    ReturnType            => 'Method::Frame::Functions::ComparisonFrame::ReturnType',
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
    my $applicable = Method::Frame::Functions::Role->new(name => 'Applicable');
    is $applicable->framed_methods->num, 0;
    is $applicable->required_framed_methods->num, 0;
    my $errors = $meta_role->apply($applicable);
    is @$errors, 0;
    is $applicable->framed_methods->num, 1;
    is $applicable->required_framed_methods->num, 1;
};

done_testing();
