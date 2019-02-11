use Test2::V0;

package Math {

    use Method::Frame;
    use Types::Standard qw( :types );

    method add => (
        isa    => Int,
        params => [ Int, Int ],
        code   => sub {
          my ($class, $num1, $num2) = @_;
          $num1 + $num2;
        },
    );

    method minus => (
        isa    => Int,
        params => [ Int, Int ],
        code   => sub {
          my ($class, $num1, $num2) = @_;
          "$num1 - $num2";
        },
    );

}

subtest 'all parameters type and return type is matched' => sub {
    is( Math->add(2, 5), 7 );
};

subtest 'parameter mismatch' => sub {
    ok(my $e = dies { Math->add("string", "string") });
    my $err_mes = quotemeta q{0Th Parameter does not pass type constraint 'Int' because : Argument value is 'string'.)};
    like $e, qr!^${err_mes}!;
};

subtest 'return type mismatch' => sub {
    ok(my $e = dies { Math->minus(5, 3) });
    my $err_mes = quotemeta q{Method 'minus's Return type does not pass type constraint 'Int' because : Method code returns '5 - 3')};
    like $e, qr!^${err_mes}!;
};

done_testing;
