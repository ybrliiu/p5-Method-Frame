package Method::Frame::Meta::Module;

use Method::Frame::Base;

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( name applied_role_names framed_methods )],
);

use Carp ();

sub new {
    my ($class, %args) = @_;
    Carp::croak q{Missing argument 'name'} unless defined $args{name};
    $args{applied_role_names} //= [];

    bless \%args, $class;
}

sub add_framed_method { Carp::croak 'This is abstract method.' }

sub consume_role { Carp::croak 'This is abstract method.' }

1;

__END__

=encoding utf-8

=head1 NAME

Method::Frame::Meta::Module - Module meta class for Method::Frame

=head1 SYNOPSIS

=head1 DESCRIPTION

Method::Frame is ...

=head1 LICENSE

Copyright (C) mp0liiu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

mp0liiu E<lt>raian@reeshome.orgE<gt>

=cut

