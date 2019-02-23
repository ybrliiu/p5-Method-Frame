use Method::Frame::Base qw( test );

use Types::Standard qw( Int Str );
use Method::Frame::Functions::ComparisonFrame::ListParameters;
use Method::Frame::Functions::ComparisonFrame::RequiredParameter;

use constant +{
    ListParameters => 
        'Method::Frame::Functions::ComparisonFrame::ListParameters',
    RequiredParameter => 
        'Method::Frame::Functions::ComparisonFrame::RequiredParameter',
};

subtest compare => sub {

    my $params = ListParameters->new([
        RequiredParameter->new(Int),
        RequiredParameter->new(Int),
    ]);

    subtest same_params => sub {
        my $same_params = ListParameters->new([
            RequiredParameter->new(Int),
            RequiredParameter->new(Int),
        ]);
        my $errors = $params->compare($same_params);
        is $errors, [];
    };

    subtest different_parameter_num => sub {
        my $diff_params = ListParameters->new([
            RequiredParameter->new(Int),
        ]);
        my $errors = $params->compare($diff_params);
        is $errors, ['Number of Parameters is different. (2 vs 1)'];
    };

    subtest different_constraints => sub {
        my $diff_params = ListParameters->new([
            RequiredParameter->new(Str),
            RequiredParameter->new(Str),
        ]);
        my $errors = $params->compare($diff_params);
        is $errors, [
            q{0Th parameter constraint is different. (Int vs Str)},
            q{1Th parameter constraint is different. (Int vs Str)}
        ];
    };

};

done_testing;
