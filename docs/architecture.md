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