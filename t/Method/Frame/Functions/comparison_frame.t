use Method::Frame::Base qw( test );

use Types::Standard qw( Int Str );
use Method::Frame::Functions::ComparisonFrame;
use Method::Frame::Functions::ComparisonFrame::RequiredParameter;
use Method::Frame::Functions::ComparisonFrame::DefaultParameter;
use Method::Frame::Functions::ComparisonFrame::OptionalParameter;
use Method::Frame::Functions::ComparisonFrame::ListParameters;
use Method::Frame::Functions::ComparisonFrame::HashParameters;
use Method::Frame::Functions::ComparisonFrame::ReturnType;

# alias
use constant +{
    RequiredParameter => 'Method::Frame::Functions::ComparisonFrame::RequiredParameter',
    DefaultParameter  => 'Method::Frame::Functions::ComparisonFrame::DefaultParameter',
    OptionalParameter => 'Method::Frame::Functions::ComparisonFrame::OptionalParameter',
    ListParameters    => 'Method::Frame::Functions::ComparisonFrame::ListParameters',
    HashParameters    => 'Method::Frame::Functions::ComparisonFrame::HashParameters',
    ReturnType        => 'Method::Frame::Functions::ComparisonFrame::ReturnType',
    Frame             => 'Method::Frame::Functions::ComparisonFrame',
};

subtest compare => sub {

    subtest same => sub {
        my $frame = Frame->new(
            name        => 'sum',
            params      => ListParameters->new([
                RequiredParameter->new(Int),
                RequiredParameter->new(Int)
            ]),
            return_type => ReturnType->new(Int),
        );
        my $same = Frame->new(
            name        => 'sum',
            params      => ListParameters->new([
                RequiredParameter->new(Int),
                RequiredParameter->new(Int)
            ]),
            return_type => ReturnType->new(Int),
        );
        my $errors = $frame->compare($same);
        is $errors, [];
    };

    subtest different_name => sub {
        my $frame = Frame->new(
            name        => 'sum',
            params      => ListParameters->new([
                RequiredParameter->new(Int),
                RequiredParameter->new(Int)
            ]),
            return_type => ReturnType->new(Int),
        );
        my $diff_name = Frame->new(
            name        => 'do_something',
            params      => ListParameters->new([
                RequiredParameter->new(Int),
                RequiredParameter->new(Int)
            ]),
            return_type => ReturnType->new(Int),
        );
        my $errors = $frame->compare($diff_name);
        is $errors, ['Frame name is different. (sum vs do_something)'];
    };

    subtest different => sub {
        my $frame = Frame->new(
            name        => 'concat',
            params      => ListParameters->new([
                RequiredParameter->new(Str),
                RequiredParameter->new(Str)
            ]),
            return_type => ReturnType->new(Str),
        );
        my $diff_name = Frame->new(
            name        => 'concat',
            params      => ListParameters->new([
                RequiredParameter->new(Int),
                RequiredParameter->new(Int)
            ]),
            return_type => ReturnType->new(Int),
        );
        my $errors = $frame->compare($diff_name);
        is $errors, [
            '0Th parameter constraint is different. (Str vs Int)',
            '1Th parameter constraint is different. (Str vs Int)',
            'ReturnType constraint is different. (Str vs Int)',
        ];

        my $has_hash_params = Frame->new(
            name        => 'concat',
            params      => HashParameters->new({
                a => RequiredParameter->new(Str),
                b => RequiredParameter->new(Str)
            }),
            return_type => ReturnType->new(Str),
        );
        my $errors2 = $frame->compare($has_hash_params);
        is $errors2, ['Parameters type is different. (list parameters vs hash parameters)'];
    };

};

done_testing;
