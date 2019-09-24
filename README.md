# 一括メールシステム ikamail

ikamail は組織内に一括でメールを送信するためのシステムです。(作成中)

ユーザーのメールアドレス情報をLDAPから取得し、条件に一致するユーザーに対してメールを一括で送信します。

##

* 言語
    * Ruby 2.5 以上、2.6 以上推奨

* OS
    * Ubuntu 18.04LTS、20.04 LTS 以上推奨
    * CentOS 8 以上

* データベース
    * MariaDB 10.1 以上、10.2.2 以上推奨

Redisが必要。

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

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## DB

Ubuntu 18.04 LTS

apt install mariadb-server
apt install libmariadbclient-dev-compat
