use Method::Frame::Base qw( test );

use Method::Frame::Functions::CompareFrame::FramedMethod::ValuesEqualityChecker qw( :all );

subtest scalar_equals => sub {
    ok scalar_equals(undef, undef);
    ok !scalar_equals(undef, 0);
    ok !scalar_equals(0, undef);
    ok scalar_equals(100, 100);
    ok !scalar_equals(0, 100);
    ok scalar_equals(3.1415, 3.1415);
    ok !scalar_equals(3.1415, 8.16);
    ok scalar_equals('string', 'string');
    ok !scalar_equals('string', 'zzz...');
    ok scalar_equals(100, '100');
    ok !scalar_equals('blah', 0.19);
};

subtest array_equals => sub {
    ok array_equals([], []);
    ok !array_equals([0], []);
    ok !array_equals([], [0]);
    ok array_equals(['A' .. 'C'], ['A' .. 'C']);
};

subtest hash_equals => sub {
    ok hash_equals(+{}, +{});
    ok !hash_equals(+{ a => 1 }, +{});
    ok !hash_equals(+{}, +{ a => 1 });
    ok hash_equals(+{ a => 1, b => 2 }, +{ a => 1, b => 2 });
};

subtest deep_equals => sub {
    ok deep_equals(
        [ 0, [1], 3 ],
        [ 0, [1], 3 ]
    );
    ok !deep_equals(
        [ 's', +{ a => 1 }, [1] ],
        [ 0, [1], 3 ]
    );
    ok deep_equals(
        +{ a => [ 0 .. 2 ], b => 10 },
        +{ a => [ 0 .. 2 ], b => 10 }
    );
    ok !deep_equals(
        +{ a => [ 0 .. 2 ], b => 10 },
        +{ c => '???', b => [] }
    );
    ok deep_equals(\100, \100);
    ok !deep_equals(\100, \"hage");
    ok !deep_equals([], \"hoge");
    ok deep_equals(\\\100, \\\100);
    ok deep_equals(\\\[ [ 1 .. 2 ] ], \\\[ [ 1 .. 2 ] ]);
    ok !deep_equals(\\\[ [ 1 .. 2 ] ], \[]);
};

package CanEqualityString {

    use Class::Accessor::Lite (
        new => 1,
        ro  => [qw( value )],
    );

    sub equals {
        my ($self, $that) = @_;
        $self->value eq $that->value;
    }

}

subtest value_equals => sub {
    ok value_equals(
        CanEqualityString->new( value => 'str' ),
        CanEqualityString->new( value => 'str' )
    );
    ok !value_equals(
        CanEqualityString->new( value => 'str' ),
        CanEqualityString->new( value => 'strstr' )
    );
    ok !value_equals(
        CanEqualityString->new( value => 'str' ),
        [ 1 .. 3],
    );
    ok !value_equals(
        0,
        CanEqualityString->new( value => 'str' ),
    );
    ok scalar_equals(undef, undef);
    ok !scalar_equals(undef, 0);
    ok !scalar_equals(0, undef);
    ok value_equals(0.35, 0.35);
    ok !value_equals('pop', 0.35);
    ok !value_equals('@@@', \100);
    ok !value_equals(+{ a => 9 }, 100);
    ok deep_equals(
        [ 0, [1], 3 ],
        [ 0, [1], 3 ]
    );
    ok !deep_equals(
        [ 's', +{ a => 1 }, [1] ],
        [ 0, [1], 3 ]
    );
    ok deep_equals(
        +{ a => [ 0 .. 2 ], b => 10 },
        +{ a => [ 0 .. 2 ], b => 10 }
    );
    ok !deep_equals(
        +{ a => [ 0 .. 2 ], b => 10 },
        +{ c => '???', b => [] }
    );
};

done_testing;
