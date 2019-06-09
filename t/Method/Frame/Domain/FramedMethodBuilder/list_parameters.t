use Method::Frame::Base qw( test );

use Method::Frame::Domain::FramedMethodBuilder::ListParameters;
use Method::Frame::Domain::FramedMethodBuilder::RequiredParameter;
use Method::Frame::Domain::FramedMethodBuilder::DefaultParameter;
use Carp ();
use Types::Standard qw( Int );

use constant +{
    ListParameters    => 'Method::Frame::Domain::FramedMethodBuilder::ListParameters',
    RequiredParameter => 'Method::Frame::Domain::FramedMethodBuilder::RequiredParameter',
    DefaultParameter  => 'Method::Frame::Domain::FramedMethodBuilder::DefaultParameter',
};

subtest new => sub {
    
    ok lives { ListParameters->new([]) };

    ok dies { ListParameters->new(+{}) };

    ok lives {
        my @parameters = (
            RequiredParameter->new(Int),
            DefaultParameter->new(Int, 0),
        );
        ListParameters->new(\@parameters);
    };

};

subtest validate => sub {
    
    subtest only_required => sub {

        my $list_parameters = ListParameters->new([
            RequiredParameter->new(Int),
            RequiredParameter->new(Int),
        ]);
         
        {
            my (undef, $err) = $list_parameters->validate(1, 2);
            ok !defined $err;
        }

         
        {
            my (undef, $err) = $list_parameters->validate('', 2);
            is $err, q{0Th Parameter does not pass type constraint 'Int' because : Argument value is ''.};
        }
         
        {
            my (undef, $err) = $list_parameters->validate(1, '');
            is $err, q{1Th Parameter does not pass type constraint 'Int' because : Argument value is ''.};
        }

        {
            my (undef, $err) = $list_parameters->validate(0);
            is $err, 'Too few args';
        }

        {
            my (undef, $err) = $list_parameters->validate(0, 1, 2);
            is $err, 'Too many args';
        }

    };

    subtest use_default => sub {

        my $list_parameters = ListParameters->new([
            DefaultParameter->new(Int, 0),
            RequiredParameter->new(Int),
            DefaultParameter->new(Int, sub { $_[0] + 10 }),
        ]);
         
        {
            my (undef, $err) = $list_parameters->validate(undef, 1, undef);
            ok !defined $err;
        }
         
        {
            my (undef, $err) = $list_parameters->validate(undef, 1, 2);
            ok !defined $err;
        }
         
        {
            my (undef, $err) = $list_parameters->validate(1, 2, 3);
            ok !defined $err;
        }

        {
            my (undef, $err) = $list_parameters->validate();
            is $err, 'Too few args';
        }

        {
            my (undef, $err) = $list_parameters->validate(0, 1, 2, 3);
            is $err, 'Too many args';
        }

    };
    
};

done_testing;
