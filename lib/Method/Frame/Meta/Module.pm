package Method::Frame::Meta::Module;

use Method::Frame::Base;

use Carp ();

sub new { Carp::croak 'This is abstract method.' }

sub add_method { Carp::croak 'This is abstract method.' }

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

