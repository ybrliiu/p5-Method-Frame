use Method::Frame::Base qw( test );

use Method::Frame::Domain::FramedMethodBuilder::HashParameters;
use Method::Frame::Domain::FramedMethodBuilder::RequiredParameter;
use Method::Frame::Domain::FramedMethodBuilder::DefaultParameter;
use Carp ();
use Types::Standard qw( Int );

use constant +{
    HashParameters    => 'Method::Frame::Domain::FramedMethodBuilder::HashParameters',
    RequiredParameter => 'Method::Frame::Domain::FramedMethodBuilder::RequiredParameter',
    DefaultParameter  => 'Method::Frame::Domain::FramedMethodBuilder::DefaultParameter',
};

subtest new => sub {
    
    ok lives { HashParameters->new(+{}) };

    ok dies { HashParameters->new([]) };

    ok lives {
        HashParameters->new(+{
            arg1 => RequiredParameter->new(Int),
            arg2 => DefaultParameter->new(Int, 0),
        });
    };

};

subtest validate => sub {
    
    subtest only_required => sub {

        my $hash_parameters = HashParameters->new(+{
            arg1 => RequiredParameter->new(Int),
            arg2 => RequiredParameter->new(Int),
        });
         
        {
            my (undef, $err) = $hash_parameters->validate(
                arg1 => 1,
                arg2 => 2
            );
            ok !defined $err;
        }

         
        {
            my (undef, $err) = $hash_parameters->validate(
                arg1 => '',
                arg2 => 0,
            );
            is $err, q{Argument 'arg1' Parameter does not pass type constraint 'Int' because : Argument value is ''.}
        }

        {
            my (undef, $err) = $hash_parameters->validate(
                arg1 => 0,
            );
            is $err, q{Argument 'arg2' does not exists.};
        }

        {
            my (undef, $err) = $hash_parameters->validate({
                arg1 => 0,
                arg2 => 1,
                arg3 => 2,
            });
            is $err, q{Parameter 'arg3' does not exists.};
        }

    };

    subtest use_default => sub {

        my $hash_parameters = HashParameters->new(+{
            arg1 => DefaultParameter->new(Int, 0),
            arg2 => RequiredParameter->new(Int),
            arg3 => DefaultParameter->new(
                Int,
                sub {
                    my %args = @_;
                    die unless exists $args{arg1};
                    $args{arg1} + 10;
                }
            ),
        });
         
        {
            my (undef, $err) = $hash_parameters->validate(arg2 => 1);
            ok !defined $err;
        }
         
        {
            my (undef, $err) = $hash_parameters->validate(
                arg1 => undef,
                arg2 => 1,
            );
            ok !defined $err;
        }
         
        {
            my (undef, $err) = $hash_parameters->validate(
                arg1 => 1,
                arg2 => 2,
                arg3 => 3,
            );
            ok !defined $err;
        }

        {
            my (undef, $err) = $hash_parameters->validate();
            is $err, q{Argument 'arg2' does not exists.};
        }

        {
            my (undef, $err) = $hash_parameters->validate(
                arg2 => 1,
                arg4 => 3,
            );
            is $err, q{Parameter 'arg4' does not exists.};
        }

    };
    
};

done_testing;
