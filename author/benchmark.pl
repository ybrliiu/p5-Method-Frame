use v5.28;
use warnings;
use utf8;
use Benchmark qw( timethese cmpthese );
use lib './lib';

package Math {

    use Mule;
    use Types::Standard qw( :types );
    use Data::Validator;

    method add => (
        isa  => Int,
        args => [ Int, Int ],
        code => sub {
          my ($class, $num1, $num2) = @_;
          $num1 + $num2;
        },
    );

    inlined_method add2 => (
        isa  => Int,
        args => [ Int, Int ],
        code => sub {
          my ($class, $num1, $num2) = @_;
          $num1 + $num2;
        },
    );

    sub add3 {
        my ($class, $num1, $num2) = @_;
        $num1 + $num2;
    }

    sub add4 {
      my $class = shift;
      state $v = Data::Validator->new(
          num1 => Int,
          num2 => Int,
      )->with(qw[ StrictSequenced ]);
      my ($num1, $num2) = @{ $v->validate(@_) }{qw( num1 num2 )};
      $num1 + $num2;
    }

}

cmpthese(
    timethese(
        0,
        +{
            add     => sub { Math->add(1, 3) },
            inlined => sub { Math->add2(1, 3) },
            nomal   => sub { Math->add3(1, 3) },
            ddv     => sub { Math->add4(1, 3) },
        }
    )
);
