use Test2::V0;

package Math {

    use Mule;
    use Types::Standard qw( :types );

    method add => (
        isa  => Int,
        args => [ Int, Int ],
        code => sub {
          my ($class, $num1, $num2) = @_;
          $num1 + $num2;
        },
    );

    method minus => (
        isa  => Int,
        args => [ Int, Int ],
        code => sub {
          my ($class, $num1, $num2) = @_;
          "$num1 - $num2";
        },
    );

}

subtest 'all parameter type and return type is matched' => sub {
    is( Math->add(2, 5), 7 );
};

subtest 'parameter mismatch' => sub {
    ok(my $e = dies { Math->add("string", "string") });
    my $err_mes = quotemeta q{0Th Parameter type is mismatch. (Aragument type is 'Int' but Parameter value is 'string'.)};
    like $e, qr!^${err_mes}!;
};

subtest 'return type mismatch' => sub {
    ok(my $e = dies { Math->minus(5, 3) });
    my $err_mes = quotemeta q{Method minus Return type is mismatch. (Constraint is 'Int' but method code returns '5 - 3')};
    like $e, qr!^${err_mes}!;
};

done_testing;
