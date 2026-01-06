# 一括メールシステム ikamail

ikamail は組織内に一括でメールを送信するためのシステムです。

ユーザーのメールアドレス情報をLDAPから取得し、条件に一致するユーザーに対してメールを一括で送信します。

## 環境

* 言語
    * Ruby 3.3 以上
    * Node.js 22 以上 (アセットファイルコンパイル時のみ使用)

* データベース
    * RDBMS
        * MariaDB 10.11 以上
        * PostgreSQL 16 以上 (未テスト)
        * SQLite 3 以上 (未テスト)
    * キーバリュー (Solidを使わない場合のみ)
        * Valkey 8 以上

* ブラウザ
    * Microsoft Edge
    * Mozilla Firefox
    * Apple Safari
    * Google Chrome

## データベース設定

### MariaDB

拡張面の漢字や絵文字等に対応するためにはutf8mb4でなければなりません。MariaDBのバージョンによってはmy.cnf等に下記設定を追加する必要があります。これはアプリ用のデータベースを作成する前に実施する必要があります。

```my.cnf
[client]
default-character-set = utf8mb4

[server]
character-set-server = utf8mb4
collation-server = utf8mb4_general_ci
```

Debian系のパッケージで提供される場合は既に設定されていますので、設定作業は不要です。また、MariaDB 11.6以降はMariaDBのデフォルトがutf8mb4とutf8mb4_uca1400_ai_ciになっているため、設定作業は不要です。

## 開発とテスト

テスト用LDAPサーバーは"test/ldap"にあります。slapdとldap-utilsを入れておいてください。`./test/ldap/run-server`でサーバーが起動します。初期データはbase.ldifを投げてください。Ubuntuでslapdサービスを起動している場合は、exmaple.ldifを投げてください。状況に応じて、config/ldap.ymlを書き換えてください。

テストにはヘッドレスなChromiumとWebDriverが必要ですが、現在テストは実装されていません。

## デプロイ

[INSTALL.md](INSTALL.md)

## アップデート

[UPDATE.md](UPDATE.md)

## 制限事項

* 宛先の最大数よりPostfixのsmtpd_recipient_limitが大きくなければならない。
* sendmailではコマンドの引数制限による制限がある。
* メール送信がエラーになってもエラーにならない。(メール送信エラーが検知できない)
* 日本語のみ対応しています。言語切替はできません。
