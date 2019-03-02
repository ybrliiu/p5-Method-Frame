package Method::Frame;
use Method::Frame::Base;
use version; our $VERSION = version->declare('v0.0.1');

use Exporter qw( import );
our @EXPORT = qw( method );

use Carp ();
use Method::Frame::Class;

sub method {
    my ($name, %args) = @_;
    Carp::croak 'Method name is missing.' unless $name;
    for my $arg_name (qw[ isa params code ]) {
        Carp::croak "Missing parameter '$arg_name'" unless $args{$arg_name};
    }

    my $maybe_err = Method::Frame::Class->add_framed_method(
        (caller)[0],
        +{
            name        => $name,
            return_type => $args{isa},
            params      => $args{params},
            code        => $args{code},
        },
    );
    Carp::croak $maybe_err if defined $maybe_err;
}

1;
__END__

=encoding utf-8

=head1 NAME

Method::Frame - Check method parameters type and return type.

=head1 SYNOPSIS

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

    ok lives { Math->add(1, 2) };
    is Math->add(1, 2), 3;
    ok dies { Math->add("string", "") };
    ok dies { Math->minus(5, 3) };


=head1 DESCRIPTION

Method::Frame is ...

=head1 LICENSE

Copyright (C) mp0liiu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

mp0liiu E<lt>raian@reeshome.orgE<gt>

=cut

