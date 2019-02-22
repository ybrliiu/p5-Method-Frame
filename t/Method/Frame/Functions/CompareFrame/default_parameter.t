use Method::Frame::Base qw( test );

use Types::Standard qw( Int Str Maybe );
use Type::Utils qw( class_type );
use Method::Frame::Functions::CompareFrame::FramedMethod::DefaultParameter;

use constant DefaultParameter =>
    'Method::Frame::Functions::CompareFrame::FramedMethod::DefaultParameter';

package String {

    sub new {
        my ($class, $string) = @_;
        bless \$string, $class;
    }

    sub equals {
        my ($self, $string) = @_;
        $$self eq $$string;
    }

}

package SomeClass {

    sub new {
        my ($class, %args) = @_;
        bless \%args, $class;
    }

}

subtest new => sub {

    subtest literal => sub {
        ok lives { DefaultParameter->new(Int, 0) };
        ok( my $e = dies { DefaultParameter->new(Int, 0.5) } );
        my $mes = quotemeta 'Default value does not pass type constraint. at ';
        like $e, qr!^$mes!;
    };

    subtest object => sub {
        ok lives { DefaultParameter->new( class_type('String'), String->new('hoge') ) };
        ok( my $e = dies { DefaultParameter->new( class_type('SomeClass'), SomeClass->new() ) } );
        my $mes = quotemeta q{Default value object can not call 'equals' method.};
        like $e, qr{^$mes};
    };

};

subtest compare_default => sub {

    subtest literal => sub {
        my $meta_param      = DefaultParameter->new(Int, 0);
        my $same_meta_param = DefaultParameter->new(Int, 0);
        ok !defined $meta_param->_compare_default($same_meta_param);
        my $diff_meta_param = DefaultParameter->new(Int, 999);
        ok( my $err = $meta_param->_compare_default($diff_meta_param) );
        is $err, q{Parameter's default value is different. (0 vs 999)};
    };

    subtest object => sub {
        my $meta_param      = DefaultParameter->new( class_type('String'), String->new('hoge') );
        my $same_meta_param = DefaultParameter->new( class_type('String'), String->new('hoge') );
        ok !defined $meta_param->_compare_default($same_meta_param);
        my $diff_meta_param = DefaultParameter->new( class_type('String'), String->new('fuga') );
        ok( my $err = $meta_param->_compare_default($diff_meta_param) );
        my $mes = quotemeta q{Parameter's default value is different. (};
        like $err, qr{^$mes};
    };

};

subtest compare => sub {

    subtest literal => sub {
        my $meta_param      = DefaultParameter->new(Int, 0);
        my $same_meta_param = DefaultParameter->new(Int, 0);
        ok !defined $meta_param->compare($same_meta_param);
        my $diff_meta_param = DefaultParameter->new(Int, 999);
        ok( my $err = $meta_param->compare($diff_meta_param) );
        is $err, q{Parameter's default value is different. (0 vs 999)};
    };

    subtest object => sub {
        my $meta_param      = DefaultParameter->new( class_type('String'), String->new('hoge') );
        my $same_meta_param = DefaultParameter->new( class_type('String'), String->new('hoge') );
        ok !defined $meta_param->compare($same_meta_param);
        my $diff_meta_param = DefaultParameter->new( class_type('String'), String->new('fuga') );
        ok( my $err = $meta_param->compare($diff_meta_param) );
        my $mes = quotemeta q{Parameter's default value is different. (};
        like $err, qr{^$mes};
    };

};

done_testing;
