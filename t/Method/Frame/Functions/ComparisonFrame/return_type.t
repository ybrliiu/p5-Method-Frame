use Method::Frame::Base qw( test );

use Types::Standard qw( Int Str );
use Method::Frame::Functions::ComparisonFrame::ReturnType;

use constant ReturnType =>
    'Method::Frame::Functions::ComparisonFrame::ReturnType';

subtest compare_constraint => sub {
    my $meta_param  = ReturnType->new(Int);
    ok !defined $meta_param->_compare_constraint( ReturnType->new(Int) );

    ok( my $err = $meta_param->_compare_constraint( ReturnType->new(Str) ) );
    is $err, q{ReturnType constraint is different. (Int vs Str)};
};

done_testing;
