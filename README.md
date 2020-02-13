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

## OS設定

本番環境でのDelayedJobが大量のファイルを監視を行う関係で、inotifyの監視数上限(デフォルトは`8192`)を超えてしまう場合があります。DelayedJobのデーモンでエラーが出る場合は、/etc/sysctl.confに下記を追加して、`sysctl -p`で読み込みを行ってください。

```/etc/sysctl.conf
fs.inotify.max_user_watches = 32768
```

設定可能な上記の最大値は`524288`です。監視数の数だけメモリを消費しますので、メモリが少ない環境では注意して設定してください。

## データベース設定

拡張面の漢字や絵文字等に対応するためにはutf8mb4でなければなりません。しかし、utf8mb4では255文字が767バイトを越えてしまうため、`innodb_large_prefix`が有効でなければなりません。MariaDB 10.2.1 以下でutf8mb4を使用する場合は以下のようにmy.cnfに追加してください。これはアプリ用のデータベースを作成する前に実施する必要があります。

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

## デプロイ

下記コマンドで準備をします。

```
git clone https://github.com/kue-ipc/ikamail.git
cd ikamail
bundle install --deployment --without development test
bundle exec rails yarn:install
RAILS_ENV=production bundle exec rails assets:precompile
```

`EDITOR=vim bundle exec rails credentials:edit`でmaster.keyを新たに生成して、credentialsに下記情報を書き込んでください。Yaml形式です。

```Yaml
secret_key_base: (自動生成)
database:
  password: データベースのパスワード
ldap:
  password: LDAPのパスワード
```


また、下記のファイルについてexample.jpの部分を環境に合わせて書き換える必要があります。

- config/environments/production.rb
- config/ldap.yml

`config/database.yml`を書き換えるか、既に書いてある内容通りのデータベースを作成してください。

```SQL
create database ikamail;
create user ikamail@'localhost' identified by 'DBユーザーのパスワード';
grant all privileges on ikamail.* to ikamail@'localhost';
flush privileges;
```

データベースの順ができたら、データベースをマイグレーションしてください。

```
RAILS_ENV=production bundle exec rails db:migrate
```

あとは、scriptsにあるサンプルを参考にサービスに登録して、起動してください。production環境ではDelayedJobを有効にすることも忘れないでください。

定期的な処理はwheneverでクーロン登録ができます。

```
bundle exec whenever --update-crontab
```

登録情報の変更等は`config/schedule.rb`を書き換えてください。その他、`batch/cron`にもバッチ処理のシェルのサンプルがあります。

## 開発とテスト

テスト用LDAPサーバーは"test/ldap"にあります。slapdとldap-utilsを入れておいてください。
`./test/ldap/run-server`でサーバーが起動します。初期データはbase.ldifを投げてください。

テストにはヘッドレスなChromiumとWebDriverが必要ですが、現在テストは実装されていません。


## 制限事項

* 宛先の最大数よりPostfixのsmtpd_recipient_limitが大きくなければならない。
* sendmailではコマンドの引数制限による制限がある。
* メール送信がエラーになってもエラーにならない。(メール送信エラーが検知できない)
