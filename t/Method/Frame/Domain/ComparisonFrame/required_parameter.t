use Method::Frame::Base qw( test );

use Types::Standard qw( Int Str );
use Method::Frame::Domain::ComparisonFrame::RequiredParameter;

use constant RequiredParameter =>
    'Method::Frame::Domain::ComparisonFrame::RequiredParameter';

subtest compare => sub {
    my $meta_param  = RequiredParameter->new(Int);
    my $meta_param2 = RequiredParameter->new(Int);
    ok !defined $meta_param->compare($meta_param2);

    my $meta_param3 = RequiredParameter->new(Str);
    ok( my $err = $meta_param->compare($meta_param3) );
    is $err, q{constraint is different. (Int vs Str)};
};

done_testing;
