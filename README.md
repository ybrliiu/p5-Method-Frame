# NAME

Method::Frame - Check method parameters type and return type.

# SYNOPSIS

    use Method::Frame;

    package Math {

        use Method::Frame;
        use Types::Stanard qw( :types );

        method add => (
            isa    => Int,
            params => [ Int, Int ],
            code   => sub {
                my ($self, $num1, $num2) = @_;
                return $num1 + $num2;
            },
        );

        method minus => (
            isa    => Int,
            params => [ Int, Int ],
            code   => sub {
                my ($self, $num1, $num2) = @_;
                "$num1 - $num2";
            },
        );

    }

    use Test2::V0;

    ok lives { Math->add(1, 2) };
    is Math->add(1, 2), 3;
    ok dies { Math->add("string", "") };
    ok dies { Math->minus(5, 3) };

# DESCRIPTION

Method::Frame is ...

# CONCEPT

- 普通のPerlのSyntaxでかける
- Moose like な構文でかける
- Mooxx 系のアクセサをよしなにしてくれるOOPフレームワークと組み合わせてもうまく動く
- しかし Mooxx 系のどのモジュールには依存しない
- コンパイル時にはチェックしない
- 代わりに静的解析しやすくして、あとから静的に型チェックできるようにする

# LICENSE

Copyright (C) mp0liiu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

mp0liiu <raian@reeshome.org>
