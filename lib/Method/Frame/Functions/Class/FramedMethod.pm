package Method::Frame::Functions::Class::FramedMethod;

use Method::Frame::Base;

use parent 'Method::Frame::Functions::ComparisonFrame';

use Carp ();

use Class::Accessor::Lite (
    new => 0,
    ro  => [qw( code )],
);

sub new {
    Carp::croak 'Too few arguments.' if @_ < 2;
    my ($class, $framed_method_builder) = @_;
    Carp::croak 'Parameter does not FrameMethodBuilder object.'
        unless $framed_method_builder->isa('Method::Frame::Functions::FramedMethodBuilder');

    # やはり Builder -> FrameMethod への変換メソッドをきちんと実装する必要がありそう.
=head1 
- FrameMethod など共通のインターフェースを作る
- FrameMethodBuilder -> FrameMethodInterface に変換
- Class::FrameMethod は FrameMethodInterface から作成
=cut
    my $self = $class->SUPER::new(
        name        => $framed_method_builder->name,
        return_type => $framed_method_builder->return_type,
        params      => $framed_method_builder->params,
    );
    $self->{code} = $framed_method_builder->code;
    $self;
}

1;
