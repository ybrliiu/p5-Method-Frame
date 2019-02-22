use Method::Frame::Base qw( test );

use Types::Standard qw( Int Str );
use Type::Utils qw( class_type );
use Method::Frame::Functions::CompareFrame::FramedMethod::ListParameters;
use Method::Frame::Functions::CompareFrame::FramedMethod::RequiredParameter;

use constant +{
    ListParameters => 
        'Method::Frame::Functions::CompareFrame::FramedMethod::ListParameters',
    RequiredParameter => 
        'Method::Frame::Functions::CompareFrame::FramedMethod::RequiredParameter',
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
            "0Th parameter constraint is different. (Int vs Str)",
            "1Th parameter constraint is different. (Int vs Str)"
        ];
    };

};

done_testing;
