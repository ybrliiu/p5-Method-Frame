use Method::Frame::Base qw( test );

use Method::Frame::Domain::FramedMethodBuilder::DefaultParameter;
use Carp ();
use Types::Standard qw( Int ArrayRef );

subtest new => sub {

    ok dies {
        Method::Frame::Domain::FramedMethodBuilder::DefaultParameter->new();
    }, 'Too few arguments';

    ok dies {
        Method::Frame::Domain::FramedMethodBuilder::DefaultParameter->new('string', 0);
    }, 'Pass not type constraint object and default value';

    ok dies {
        Method::Frame::Domain::FramedMethodBuilder::DefaultParameter->new(Int, 'string');
    }, 'Default value does not pass type constraint';

    ok lives {
        Method::Frame::Domain::FramedMethodBuilder::DefaultParameter->new(Int, 0);
    }, 'Pass type constraint object and default value';

    ok dies {
        Method::Frame::Domain::FramedMethodBuilder::DefaultParameter->new(ArrayRef, sub { 0 });
    }, 'The return value of the function that returns default value has not pass typeconstraint.';

    ok lives {
        Method::Frame::Domain::FramedMethodBuilder::DefaultParameter->new(ArrayRef, sub { [] });
    }, 'The return value of the function that returns default value has pass typeconstraint.';

    ok lives {
        my $default_func = sub {
            Carp::croak 'Too few arguments' if @_ < 1;
            $_[0] ** $_[0];
        };
        Method::Frame::Domain::FramedMethodBuilder::DefaultParameter->new(ArrayRef, $default_func);
    }, 'If you need to pass arguments to execute a function that returns a default value, '
        . 'this module can not check that the function passes the type constraint.';

};

subtest 'validate use literal default value' => sub {

    my $param = Method::Frame::Domain::FramedMethodBuilder::DefaultParameter->new(Int, 0);

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

subtest 'validate use reference default value' => sub {

    my $default_func = sub { [] };
    my $param = Method::Frame::Domain::FramedMethodBuilder::DefaultParameter->new(ArrayRef, $default_func);

    {
        my ($valid_arg, $err) = $param->validate([]);
        is $valid_arg, [], 'Pass type constraint';
        ok !defined $err, 'No error';
    }

    {
        my ($valid_arg, $err) = $param->validate(undef);
        is $valid_arg, [], 'Default value used';
        ok !defined $err, 'No error';
    }

    {
        my ($valid_arg, $err) = $param->validate('string');
        ok !defined $valid_arg, 'Does not pass type constraint';
        is $err, q{Parameter does not pass type constraint 'ArrayRef' because : Argument value is 'string'.};
    }

};

done_testing;
