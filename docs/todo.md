# 予定
- Roleの使用
- Interfaceの廃止

# Method::Frame 機能一覧
- Frameの比較
- FramedMethodの作成
- AbstractFramedMethodの作成?
- Class-FramedMethodの追加
- Role-AbstractFramedMethodの追加
- Role-Roleへの適用
  - observerパターン使うと良さそうかもしれないね
- Role-Classへの適用

# リファクタリング箇所
- シュガー関数のバックエンドモジュールの場所の変更
- 一貫性のないところをなくす
  - 型チェック, エラーメッセージ
  - 引数チェック
- ParametersFactoryなどの場所は適切か?

# 優先度低
- 複数の返り値に対応
- Method Modifiers に対応
- Class-FramedMethodのoverride?
    - 子クラスから親クラスのメソッド呼ぶ時のオーバーヘッドが気になる
        1. framedではない別メソッドを用意し, 直接呼び出す
          - 機能追加は必要ない
          - ライブラリ利用者がすこし面倒な思いをする
        2. super() もしくは unframed() みたいなシュガー関数で,  親クラスのメソッドのcodeだけを呼び出せるようにする
          - しかし親クラスのメソッドのcodeを見つけるためのオーバヘッドもあるのでパフォーマンスは期待できなさそう
          - できればoverride時以外呼び出せないようにする?
              - オーバーロード対応時に困りそう
        3. around の $orig みたいな, $superを渡すのを作る?
          - override do_something => ( isa => Int, params => [ Int ], code => sub { my ($super, $self, $num) = @_; } )
          - ちょいきもい
          - オーバーヘッドなし
          - オーバーロード対応は楽そう
          - 継承ツリーを動的にいじられるときちんと動作しなさそう
