# About architecture
- Method::Frame
    - 何もしないモジュール・・・でも良かったけど、Mooseを真似て Method::Frame::Class が提供する関数へのエイリアスを貼る
- Method::Frame::Base
- Method::Frame::Class
    - Class関係のシュガー関数の提供
- Method::Frame::Role
    - Role関係のシュガー関数を提供する
- Method::Frame::SugerBackEnd
    - シュガー関数のバックエンド
    - Applicatin Service を行う層
    - DomainのRepositoryでStoreからEntityを作って利用
- Method::Frame::Domain
    - コアとなるビジネスロジックの置き場所
- Method::Frame::Store
    - モジュールのメタデータを保管する場所


Module::PrameterFactory などを用意

SugerBackEnd::Class::add_framed_method では, 
```perl
sub add_framed_method {
    my ($class, $class_name, $method_options) = @_;

    my $meta_class = Method::Frame::Store::MetaClassStore->maybe_get($class_name)
        // Method::Frame::Domain::Module::Class->new(
               name => $class_name,
               add_framed_method_observers => [ sub {} ],
          );

    my $framed_method = Method::Frame::Domain::Module::FramedMethod->new(
        name        => $method_options->{name},
        params      => ParametersFactory->create($method_options->{params}),
        return_type => ReturnTypeFactory->create($method_options->{return_type}),
        code        => $method_options->{code},
    );

    if ( my $err = $meta_class->add_framed_method($framed_method) ) {
        $err;
    }
    else {
        my $builder = Method::Frame::Domain::FramedMethodBuilder->new($framed_method, $method_options{code});
        $meta_class->add_subroutine($framed_method->name, $builder->build);
        Method::Frame::Store::MetaClassStore->store($meta_class);
        undef;
    }
}
```
