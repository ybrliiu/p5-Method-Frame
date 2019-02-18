use Method::Frame::Base qw( test );

use Method::Frame::Meta::Role;
use Method::Frame::Meta::Module::AbstractFramedMethod;
use Types::Standard qw( Int Maybe );

subtest new => sub {
    ok lives { Method::Frame::Meta::Role->new( name => 'ANON' ) };
};

subtest add_abstract_framed_method => sub {

    my $meta_role = Method::Frame::Meta::Role->new( name => 'ANON' );

    ok dies { $meta_role->add_abstract_framed_method(+{}) };

    my $abstract_framed_method = Method::Frame::Meta::Module::AbstractFramedMethod->new(
        name        => 'add',
        params      => [ Int, Int ],
        return_type => Int,
    );
    my $err = $meta_role->add_abstract_framed_method($abstract_framed_method);
    ok not defined $err;

    my $err2 = $meta_role->add_abstract_framed_method($abstract_framed_method);
    is $err2, q{Abstract framed method 'add' is already exists};

};

subtest consume_role => sub {
};

done_testing;
