# 一括メールシステム ikamail

ikamail は組織内に一括でメールを送信するためのシステムです。(作成中)

ユーザーのメールアドレス情報をLDAPから取得し、条件に一致するユーザーに対してメールを一括で送信します。

## 環境

* 言語
    * Ruby 2.5 以上 (2.6 以上推奨)
    * Node.js 10以上 (アセットファイルコンパイル時のみ使用、12以上推奨)

* OS
    * Ubuntu 18.04LTS、20.04LTS(予定)
    * CentOS 7(with SCL)、8

* データベース
    * MariaDB 10.1 以上、10.2.2 以上推奨

## データベース設定(MraiaDB)

絵文字等に対応する場合はutf8mb4でなければなりません。しかし、utf8mb4では255文字が767バイトを越えてしまいますので`innodb_large_prefix`が有効でなければなりません。MariaDB 10.2.1 以下の場合、以下のようにmy.cnfに追加してください。

```my.cnf
[mysqld]
innodb_file_format = Barracuda
innodb_file_per_table
innodb_large_prefix
innodb_default_row_format = DYNAMIC

character-set-server  = utf8mb4
collation-server      = utf8mb4_general_ci
```

MariaDB 10.2.2 以上は上記のInnoDB設定がデフォルトであるため、不要です。

### カーネル設定

inotifyの最大監視数がデフォルトの8192では足りなくなる場合があります。ジョブのデーモンでエラーが出る場合は、/etc/sysctl.confに下記を追加してください。

```/etc/sysctl.conf
fs.inotify.max_user_watches = 32768
```

## 開発とテスト

テスト用LDAPサーバーは"test/ldap"にあります。slapdとldap-utilsを入れておいてください。
`./test/ldap/run-server`でサーバーが起動します。初期データはbase.ldifを投げてください。

テストにはヘッドレスなChromiumとWebDriverが必要ですが、現在テストは実装されていません。

## デプロイ

下記のファイルについてexample.jpの部分を環境に合わせて書き換える必要があります。

- config/environments/production.rb
- config/ldap.yml

master.keyを新たに生成して、credentialsに下記情報を書き込んでください。

```
database:
  password: データベースのパスワード
ldap:
  password: LDAPのパスワード
secret_key_base: (自動生成)
```

## 制限事項

* 宛先の最大数よりPostfixのsmtpd_recipient_limitが大きくなければならない。
* sendmailではコマンドの引数制限による制限がある。
* メール送信がエラーになってもエラーにならない。(メール送信エラーが検知できない)
