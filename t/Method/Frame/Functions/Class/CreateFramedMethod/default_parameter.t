use Method::Frame::Base qw( test );

use Method::Frame::Functions::Class::CreateFramedMethod::DefaultParameter;
use Types::Standard qw( Int );

subtest new => sub {

    ok dies {
        Method::Frame::Functions::Class::CreateFramedMethod::DefaultParameter->new();
    }, 'To few arguments';

    ok dies {
        Method::Frame::Functions::Class::CreateFramedMethod::DefaultParameter->new('string', 0);
    }, 'Pass not type constraint object and default value';

    ok dies {
        Method::Frame::Functions::Class::CreateFramedMethod::DefaultParameter->new(Int, 'string');
    }, 'Default value does not pass type constraint';

    ok lives {
        Method::Frame::Functions::Class::CreateFramedMethod::DefaultParameter->new(Int, 0);
    }, 'Pass type constraint object and default value';

};

subtest validate => sub {

    my $param = Method::Frame::Functions::Class::CreateFramedMethod::DefaultParameter->new(Int, 0);

    {
        my ($valid_arg, $err) = $param->validate(100);
        is $valid_arg, 100, 'Pass type constraint';
        ok !defined $err, 'No error';
    }

    {
        my ($valid_arg, $err) = $param->validate(undef);
        is $valid_arg, 0, 'Default value used';
        ok !defined $err, 'No error';
    }

    {
        my ($valid_arg, $err) = $param->validate('string');
        ok !defined $valid_arg, 'Does not pass type constraint';
        is $err, q{Parameter does not pass type constraint 'Int' because : Argument value is 'string'.};
    }

};

done_testing;
