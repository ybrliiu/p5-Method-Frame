use Method::Frame::Base qw( test );

use Types::Standard qw( Int Maybe );
use Method::Frame::Functions::ComparisonFrame::RequiredParameter;
use Method::Frame::Functions::ComparisonFrame::DefaultParameter;
use Method::Frame::Functions::ComparisonFrame::OptionalParameter;

use constant +{
    RequiredParameter => 
        'Method::Frame::Functions::ComparisonFrame::RequiredParameter',
    DefaultParameter => 
        'Method::Frame::Functions::ComparisonFrame::DefaultParameter',
    OptionalParameter => 
        'Method::Frame::Functions::ComparisonFrame::OptionalParameter',
};

subtest compare_type => sub {
    my $required = RequiredParameter->new(Int);
    ok !defined $required->_compare_type( RequiredParameter->new(Int) );

    my $default = DefaultParameter->new(Int, 0);
    ok( my $err = $required->_compare_type($default) );
    is $err, 'type is different. (required parameter vs default parameter)';

    my $optional = OptionalParameter->new(Maybe[Int]);
    ok( my $err2 = $default->_compare_type($optional) );
    is $err2, 'type is different. (default parameter vs optional parameter)';
};

subtest compare => sub {
    my $required = RequiredParameter->new(Int);
    ok !defined $required->compare( RequiredParameter->new(Int) );

    my $default = DefaultParameter->new(Int, 0);
    ok( my $err = $required->compare($default) );
    is $err, 'type is different. (required parameter vs default parameter)';

    my $optional = OptionalParameter->new(Maybe[Int]);
    ok( my $err2 = $default->compare($optional) );
    is $err2, 'type is different. (default parameter vs optional parameter)';
};

done_testing;
