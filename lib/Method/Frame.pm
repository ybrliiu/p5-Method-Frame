package Method::Frame;
use Method::Frame::Base;
use version; our $VERSION = version->declare('v0.0.1');

use Exporter qw( import );
our @EXPORT = qw( method );

use Carp ();
use Sub::Install ();
use Method::Frame::Meta::Method;

sub method {
    my ($name, %args) = @_;
    Carp::croak 'Method name is missing.' unless $name;
    for my $arg_name (qw[ isa params code ]) {
        Carp::croak "Missing parameter '$arg_name'" unless $args{$arg_name};
    }

    my $meta_method = Method::Frame::Meta::Method->new(
        name        => $name,
        return_type => $args{isa},
        params      => $args{params},
        code        => $args{code},
    );
    Sub::Install::install_sub({
        code => $meta_method->build,
        into => (caller)[0],
        as   => $name,
    });
}

1;
__END__

=encoding utf-8

=head1 NAME

Method::Frame - It's new $module

=head1 SYNOPSIS

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


=head1 DESCRIPTION

Method::Frame is ...

=head1 LICENSE

Copyright (C) mp0liiu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

mp0liiu E<lt>raian@reeshome.orgE<gt>

=cut

