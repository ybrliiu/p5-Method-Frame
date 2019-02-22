use Method::Frame::Base qw( test );

use Types::Standard qw( Int );
use Method::Frame::Functions::CompareFrame::FramedMethod::ListParameters;
use Method::Frame::Functions::CompareFrame::FramedMethod::HashParameters;

use constant +{
    ListParameters => 
        'Method::Frame::Functions::CompareFrame::FramedMethod::ListParameters',
    HashParameters => 
        'Method::Frame::Functions::CompareFrame::FramedMethod::HashParameters',
};

subtest compare_type => sub {
    my $list = ListParameters->new([]);
    ok !defined $list->_compare_type( ListParameters->new([]) );
    ok( my $err = $list->_compare_type( HashParameters->new(+{}) ) );
    is $err, 'Parameters type is different. (list parameters vs hash parameters)';
};

subtest compare => sub {
    my $list = ListParameters->new([]);
    ok( my $err = $list->compare( ListParameters->new([]) ) );
    is $err, [];
    ok( my $err2 = $list->compare( HashParameters->new(+{}) ) );
    is $err2, ['Parameters type is different. (list parameters vs hash parameters)'];
};

done_testing;
