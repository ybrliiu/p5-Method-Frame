use Method::Frame::Base qw( test );

use Types::Standard qw( Int Str );
use Method::Frame::Functions::CompareFrame::FramedMethod::HashParameters;
use Method::Frame::Functions::CompareFrame::FramedMethod::RequiredParameter;

use constant +{
    HashParameters => 
        'Method::Frame::Functions::CompareFrame::FramedMethod::HashParameters',
    RequiredParameter => 
        'Method::Frame::Functions::CompareFrame::FramedMethod::RequiredParameter',
};

subtest compare => sub {

    my $params = HashParameters->new(+{
        a => RequiredParameter->new(Int),
        b => RequiredParameter->new(Int),
    });

    subtest same_params => sub {
        my $same_params = HashParameters->new(+{
            a => RequiredParameter->new(Int),
            b => RequiredParameter->new(Int),
        });
        my $errors = $params->compare($same_params);
        is $errors, [];
    };

    subtest too_few_keys => sub {
        my $diff_params = HashParameters->new(+{});
        my $errors = $params->compare($diff_params);
        is $errors, [
            q{Parameter 'a' does not exists.},
            q{Parameter 'b' does not exists.},
        ];
    };

    subtest too_many_keys => sub {
        my $diff_params = HashParameters->new(+{
            a => RequiredParameter->new(Int),
            b => RequiredParameter->new(Int),
            c => RequiredParameter->new(Int),
            d => RequiredParameter->new(Int),
        });
        my $errors = $params->compare($diff_params);
        is $errors, [
            q{Compare parameter 'c' does not use.},
            q{Compare parameter 'd' does not use.},
        ];
    };

    subtest different_constraints => sub {
        my $diff_params = HashParameters->new(+{
            a => RequiredParameter->new(Str),
            b => RequiredParameter->new(Str),
        });
        my $errors = $params->compare($diff_params);
        is $errors, [
            q{Parameter 'a' constraint is different. (Int vs Str)},
            q{Parameter 'b' constraint is different. (Int vs Str)},
        ];
    };

};

done_testing;
