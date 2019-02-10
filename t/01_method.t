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

is( Math->add(2, 5), 7 );
ok dies { Math->add("string", "string") };
ok dies { Math->minus(5, 3) };

done_testing;
