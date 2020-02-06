# 一括メールシステム ikamail

ikamail は組織内に一括でメールを送信するためのシステムです。(作成中)

ユーザーのメールアドレス情報をLDAPから取得し、条件に一致するユーザーに対してメールを一括で送信します。

## 環境

* 言語
    * Ruby 2.5 以上、2.6 以上推奨
    * Node.js 8以上 (アセットファイルコンパイル時のみ使用)

* OS
    * Ubuntu 18.04LTS、20.04 LTS 以上推奨
    * CentOS 8 以上
    * CentOS 7 with SCL

* データベース
    * MariaDB 10.1 以上、10.2.2 以上推奨

* Configuration

* データベース設定(MraiaDB)

MariaDB 10.2.1 以下の場合

絵文字等に対応する場合はutf8mb4でなければなりません。しかし、utf8mb4では255文字が767バイトを越えてしまいますので`innodb_large_prefix`が有効でなければなりません。以下のようにmy.cnfに追加してください。

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

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## DB

Ubuntu 18.04 LTS

apt install mariadb-server
apt install libmariadbclient-dev-compat

## 開発とテスト

テスト用LDAPサーバーは"test/ldap"にあります。slapdとldap-utilsを入れておいてください。
`./test/ldap/run-server`でサーバーが起動します。初期データはbase.ldifを投げてください。

テストにはヘッドレスなChromiumとWebDriverが必要です。
chromium-chromedriver

## デプロイ

下記のファイルについてexample.jpの部分を環境に合わせて書き換える必要があります。

- config/environments/production.rb
- config/ldap.yml

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
