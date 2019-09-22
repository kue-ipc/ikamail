# 一括メールシステム ikamail

ikamail は組織内に一括でメールを送信するためのシステムです。(作成中)

ユーザーのメールアドレス情報をLDAPから取得し、条件に一致するユーザーに対してメールを一括で送信します。

##

* 言語
    * Ruby 2.5 以上

* OS
    * Ubuntu 18.04LTS
    * CentOS 8

* データベース
    * MariaDB 10.1 以上

* Configuration

* データベース設定(MraiaDB)

絵文字等に対応する場合はutf8mb4でなければなりません。しかし、utf8mb4では255文字が767バイトを越えてしまいますので`innodb_large_prefix`が有効でなければなりません。以下のようにmy.cnfに追加してください。`innodb_default_row_format`は`DYNAMIC`と`COMPRESSED`のどちらでも構いません。

```my.cnf
[mysqld]
innodb_file_format = Barracuda
innodb_file_per_table
innodb_large_prefix
innodb_default_row_format = DYNAMIC
#innodb_default_row_format = COMPRESSED

character-set-server  = utf8mb4
collation-server      = utf8mb4_general_ci
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
