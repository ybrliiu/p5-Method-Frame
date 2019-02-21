use Method::Frame::Base qw( test );

use Types::Standard qw( Int );
use Method::Frame::Functions::FramedMethodBuilder::RequiredParameter;

subtest new => sub {

    ok dies {
        Method::Frame::Functions::FramedMethodBuilder::RequiredParameter->new();
    }, 'No arguments';

    ok dies {
        Method::Frame::Functions::FramedMethodBuilder::RequiredParameter->new('string')
    }, 'Pass not type constraint object';

    ok lives {
        Method::Frame::Functions::FramedMethodBuilder::RequiredParameter->new(Int);
    }, 'Pass type constraint object';

};

subtest validate => sub {
    
    my $param = Method::Frame::Functions::FramedMethodBuilder::RequiredParameter->new(Int);

    {
        my ($valid_arg, $err) = $param->validate(100);
        is $valid_arg, 100, 'Pass type constraint';
        ok !defined $err, 'Has not error';
    }

    {
        my ($valid_arg, $err) = $param->validate('string');
        ok !defined $valid_arg, 'Does not pass type constraint';
        is $err, q{Parameter does not pass type constraint 'Int' because : Argument value is 'string'.};
    }

};

done_testing;
