use Method::Frame::Base qw( test );

use Method::Frame::Domain::FramedMethodBuilder::ListParameters;
use Carp ();
use Types::Standard qw( Int ArrayRef );

use constant +{
    ListParameters => 'Method::Frame::Domain::FramedMethodBuilder::ListParameters',
};

subtest new => sub {
    
    ok lives { ListParameters->new([]) };

};

done_testing;
