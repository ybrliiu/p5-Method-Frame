# NAME

Method::Frame - Check method parameters type and return type.

# SYNOPSIS

    use Method::Frame;

    package Math {

        use Method::Frame;
        use Types::Stanard qw( :types );

        method add => (
            isa  => Int,
            args => [ Int, Int ],
            code => sub {
                my ($self, $num1, $num2) = @_;
                return $num1 + $num2;
            },
        );

        method minus => (
            isa  => Int,
            args => [ Int, Int ],
            code => sub {
                my ($self, $num1, $num2) = @_;
                "$num1 - $num2";
            },
        );

    }

    use Test2::V0;
    my $sum;
    lives_ok { $sum = Math->add(1, 2) };
    is $sum, 3;
    dies_ok { Math->add("string", "") };

    dies_ok { Math->minus(5, 3) };

# DESCRIPTION

Method::Frame is ...

# LICENSE

Copyright (C) mp0liiu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

mp0liiu <raian@reeshome.org>
