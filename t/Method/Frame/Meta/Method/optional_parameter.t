use Method::Frame::Base qw( test );

use Method::Frame::Meta::Method::OptionalParameter;
use Types::Standard qw( Int Maybe );

subtest new => sub {

    ok dies {
        Method::Frame::Meta::Method::OptionalParameter->new();
    }, 'No arguments';

    ok dies {
        Method::Frame::Meta::Method::OptionalParameter->new('string');
    }, 'Pass not type constraint object';

    ok dies {
        Method::Frame::Meta::Method::OptionalParameter->new('string', 0);
    }, 'Pass not type constraint object and default value';

    ok lives {
        Method::Frame::Meta::Method::OptionalParameter->new(Int);
    }, 'Pass type constraint object';

    ok lives {
        Method::Frame::Meta::Method::OptionalParameter->new(Int, 0);
    }, 'Pass type constraint object and default value';

};

subtest validate => sub {

    subtest 'Parameter has default value' => sub {

        my $param = Method::Frame::Meta::Method::OptionalParameter->new(Int, 0);

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

    subtest 'Optional parameter' => sub {

        # Optional parameter's type is SomeType or Undef,
        # so We should be pass type constraint Maybe[`a] when make optional parameter.
        my $param = Method::Frame::Meta::Method::OptionalParameter->new(Maybe[Int]);

        {
            my ($valid_arg, $err) = $param->validate(100);
            is $valid_arg, 100, 'Pass type constraint (Int)';
            ok !defined $err, 'No error';
        }

        {
            my ($valid_arg, $err) = $param->validate(undef);
            ok !defined $valid_arg, 'Pass type constraint (Maybe)';
            ok !defined $err, 'No error';
        }

        {
            my ($valid_arg, $err) = $param->validate('string');
            ok !defined $valid_arg, 'Does not pass type constraint';
            is $err, q{Parameter does not pass type constraint 'Maybe[Int]' because : Argument value is 'string'.};
        }

    };

    subtest 'Optional parameter (when type constraint is not Maybe[`a])' => sub {

        my $param = Method::Frame::Meta::Method::OptionalParameter->new(Int);

        {
            my ($valid_arg, $err) = $param->validate(100);
            is $valid_arg, 100, 'Pass type constraint (Int)';
            ok !defined $err, 'No error';
        }

        {
            my ($valid_arg, $err) = $param->validate(undef);
            ok !defined $valid_arg, 'Try to use default value (undef)';
            is $err, q{Parameter does not pass type constraint 'Int' because : Argument value is ''.};
        }

        {
            my ($valid_arg, $err) = $param->validate('string');
            ok !defined $valid_arg, 'Does not pass type constraint';
            is $err, q{Parameter does not pass type constraint 'Int' because : Argument value is 'string'.};
        }

    };

};

done_testing;
