# 一括メールシステム ikamail

ikamail は組織内に一括でメールを送信するためのシステムです。

ユーザーのメールアドレス情報をLDAPから取得し、条件に一致するユーザーに対してメールを一括で送信します。

## 環境

* 言語
    * Ruby 3.3 以上
    * Node.js 22 以上 (アセットファイルコンパイル時のみ使用)

* データベース
    * MariaDB 10.5 以上
    * Redis 6 以上 7.2 以下 または Valkey 8 以上

* ブラウザ
    * Microsoft Edge
    * Mozilla Firefox
    * Apple Safari
    * Google Chrome

## OS設定

ジョブをRedisで管理するため、inotiyの監視数上限設定は不要となりました。

## データベース設定

拡張面の漢字や絵文字等に対応するためにはutf8mb4でなければなりません。utf8mb4を使用する場合は以下のようにmy.cnfに追加の必要がある場合があります。これはアプリ用のデータベースを作成する前に実施する必要があります。

```my.cnf
[client]
default-character-set = utf8mb4

[server]
character-set-server = utf8mb4
collation-server = utf8mb4_general_ci
```

## デプロイ

下記コマンドでクローンおよび必要なライブラリをインストールします。

```
git clone https://github.com/kue-ipc/ikamail.git
cd ikamail
bundle config set --local deployment 'true'
bundle config set --local path 'vendor/bundle'
bundle config set --local without 'development test'
bundle install
bundle exec rails yarn:install
```

コマンドがエラーになった場合は、Ruby、Node.js、Yarnが正常にインストールされているかを確認してください。

下記コマンドでcredentialsを作成します。

```
EDITOR=vim bundle exec rails credentials:edit
```

redentialsにデータベースやLDAPのアカウント情報をYAML形式で記入してください。最初の実行で"config/master.key"と"config/credentials.yml.enc"を新たに作成されます。編集する場合は、上記のコマンドを再度実行してください。追加する項目は"config/credentials.yml.sample"を参考にしてください。"config/master.key"は漏洩しないように注意してください。ファイルではなく、環境変数`RAILS_MASTER_KEY`で渡すようにすることもできます。

続いてLDAPの設定を行います。下記コマンドで"config/ldap_production.yml.sapmle"のコピーとして"config/ldap_production.yml"を作成し、編集します。

```
cp -ip config/ldap_production.yml.sapmle config/ldap_production.yml
vim config/ldap_production.yml
```

サンプルを参考に、バインドアカウント以外のLDAP情報を記入してください。バインドアカウント情報はcredentialsに記入してください。

下記コマンドでアセットファイルを事前コンパイルを行います。

```
RAILS_ENV=production bundle exec rails assets:precompile
```

データベースに専用のデータベースとユーザーを作成します。データベースのデフォルト接続先はlocalhostのMariaDBで、データベース名はikamailです。環境変数`DATABASE_URL`を使用してください。

```SQL
create database ikamail;
create user ikamail@'localhost' identified by 'DBユーザーのパスワード';
grant all privileges on ikamail.* to ikamail@'localhost';
flush privileges;
```

データベースの準備ができたら、データベースをマイグレーションしてください。

```sh
RAILS_ENV=production bundle exec rails db:migrate
```

あとは、doc/scriptsにあるサンプルを参考にサービスに登録して、起動してください。production環境ではDelayedJobを有効にすることも忘れないでください。

定期的な処理はwheneverでクーロン登録ができます。

```sh
bundle exec whenever --update-crontab
```

登録情報の変更等は`config/schedule.rb`を書き換えてください。その他、`batch/cron`にもバッチ処理のシェルのサンプルがあります。

## 開発とテスト

テスト用LDAPサーバーは"test/ldap"にあります。slapdとldap-utilsを入れておいてください。`./test/ldap/run-server`でサーバーが起動します。初期データはbase.ldifを投げてください。Ubuntuでslapdサービスを起動している場合は、exmaple.ldifを投げてください。状況に応じて、config/ldap.ymlを書き換えてください。

テストにはヘッドレスなChromiumとWebDriverが必要ですが、現在テストは実装されていません。

## アップデート方法

メジャーバージョンアップデートやマイナーバージョンアップデートでは、言語やデータベースのサポートバージョンが変更される場合があります。アプリのアップデートの前に、言語やデータベースをアップデートしてください。

メジャーバージョンやマイナーバージョンのアップデートは、最新リビジョンからのみサポートします。ブランチを変更する前に、現在のブランチの最新状態にして動作を確かめてください。アップデート後は必ず`rails db:migrate`を実施してください。

```sh
git pull
RAILS_ENV=production bundle exec rails db:migrate
git checkout __next_version_branch__
git pull
RAILS_ENV=production bundle exec rails db:migrate
```

## 制限事項

* 宛先の最大数よりPostfixのsmtpd_recipient_limitが大きくなければならない。
* sendmailではコマンドの引数制限による制限がある。
* メール送信がエラーになってもエラーにならない。(メール送信エラーが検知できない)
* 日本語のみ対応しています。言語切替はできません。
