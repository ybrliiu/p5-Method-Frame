use Method::Frame::Base qw( test );

use Types::Standard qw( Int Maybe );
use Method::Frame::Functions::Class::CreateFramedMethod::OptionalParameter;

subtest new => sub {

    ok dies {
        Method::Frame::Functions::Class::CreateFramedMethod::OptionalParameter->new();
    }, 'Too few arguments';

    ok dies {
        Method::Frame::Functions::Class::CreateFramedMethod::OptionalParameter->new(Int);
    }, 'Optional value does not pass type constraint.';

    ok lives {
        # Optional parameter's type is SomeType or Undef,
        # so We should be pass type constraint Maybe[`a] when make optional parameter.
        Method::Frame::Functions::Class::CreateFramedMethod::OptionalParameter->new(Maybe[Int]);
    }, 'Pass type constraint object and default value';
    diag $@;

};

subtest validate => sub {

    my $param = Method::Frame::Functions::Class::CreateFramedMethod::OptionalParameter->new(Maybe[Int]);

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

done_testing;
