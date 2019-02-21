use Method::Frame::Base qw( test );

use Types::Standard qw( Int Str );
use Method::Frame::Functions::CompareFrame::FramedMethod::RequiredParameter;

subtest compare => sub {
    my $meta_param =
        Method::Frame::Functions::CompareFrame::FramedMethod::RequiredParameter->new(Int);
    my $meta_param2 =
        Method::Frame::Functions::CompareFrame::FramedMethod::RequiredParameter->new(Int);
    ok !defined $meta_param->compare($meta_param2);
    my $meta_param3 =
        Method::Frame::Functions::CompareFrame::FramedMethod::RequiredParameter->new(Str);
    ok( my $err = $meta_param->compare($meta_param3) );
    is $err, 'MetaParameter constraint is different. (Int vs Str)';
};

done_testing;
