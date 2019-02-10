use Test2::V0;

package Math {

    use Mule;
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
    my $err_mes = quotemeta q{0Th Parameter type is mismatch. (Parameter type is 'Int' but Argument value is 'string'.)};
    like $e, qr!^${err_mes}!;
};

subtest 'return type mismatch' => sub {
    ok(my $e = dies { Math->minus(5, 3) });
    my $err_mes = quotemeta q{Method minus Return type is mismatch. (Constraint is 'Int' but method code returns '5 - 3')};
    like $e, qr!^${err_mes}!;
};

done_testing;
