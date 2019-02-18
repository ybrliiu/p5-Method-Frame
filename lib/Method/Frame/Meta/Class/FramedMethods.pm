package Method::Frame::Meta::Class::FramedMethods;

use Method::Frame::Base;

use parent 'Method::Frame::Meta::Module::FramedMethods';

sub implement {
    my ($self, $abstract_framed_method) = @_;

    my $maybe_method = $self->{ $abstract_framed_method->name };
    if ( !defined $maybe_method ) {
        "Method '@{[ $abstract_framed_method->name ]}' does not exists. "
            . 'so Abstract framed method can not implement';
    }
    else {
        my $method = $maybe_method;
        my $maybe_err = $method->implement($abstract_framed_method);
    }
}

1;
