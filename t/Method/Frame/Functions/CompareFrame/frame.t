use Method::Frame::Base qw( test );

use Types::Standard qw( Int Str );
use Method::Frame::Functions::CompareFrame::Frame;

# alias
use constant Frame => 'Method::Frame::Functions::CompareFrame::Frame';

subtest compare => sub {

    subtest same => sub {
        my $frame = Frame->new(
            name        => 'sum',
            params      => [ Int, Int ],
            return_type => Int,
        );
        my $same = Frame->new(
            name        => 'sum',
            params      => [ Int, Int ],
            return_type => Int,
        );
        my $errors = $frame->compare($same);
        is $errors, [];
    };

    subtest different_name => sub {
        my $frame = Frame->new(
            name        => 'sum',
            params      => [ Int, Int ],
            return_type => Int,
        );
        my $diff_name = Frame->new(
            name        => 'do_something',
            params      => [ Int, Int ],
            return_type => Int,
        );
        my $errors = $frame->compare($diff_name);
        is $errors, ['Frame name is different. (sum vs do_something)'];
    };

    subtest different => sub {
        my $frame = Frame->new(
            name        => 'concat',
            params      => [ Str, Str ],
            return_type => Str,
        );
        my $diff_name = Frame->new(
            name        => 'concat',
            params      => [ Int, Int ],
            return_type => Int,
        );
        my $errors = $frame->compare($diff_name);
        is $errors, [
            '0Th parameter constraint is different. (Str vs Int)',
            '1Th parameter constraint is different. (Str vs Int)',
            'ReturnType constraint is different. (Str vs Int)',
        ];

        my $has_hash_params = Frame->new(
            name        => 'concat',
            params      => +{ a => Str, b => Str },
            return_type => Str,
        );
        my $errors2 = $frame->compare($has_hash_params);
        is $errors2, ['Parameters type is different. (list parameters vs hash parameters)'];
    };

};

done_testing;
