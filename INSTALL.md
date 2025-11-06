# インストール

下記コマンドでクローンおよび必要なライブラリをインストールします。

```sh
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

```sh
EDITOR=vim bin/rails credentials:edit
```

credentialsにデータベースやLDAPのアカウント情報をYAML形式で記入してください。最初の実行で"config/master.key"と"config/credentials.yml.enc"を新たに作成されます。編集する場合は、上記のコマンドを再度実行してください。追加する項目は"config/credentials.yml.sample"を参考にしてください。"config/master.key"は漏洩しないように注意してください。ファイルではなく、環境変数`RAILS_MASTER_KEY`で渡すようにすることもできます。

続いてLDAPの設定を行います。下記コマンドで"config/ldap_production.yml.sapmle"のコピーとして"config/ldap_production.yml"を作成し、編集します。

```sh
cp -ip config/ldap_production.yml.sapmle config/ldap_production.yml
vim config/ldap_production.yml
```

サンプルを参考に、バインドアカウント以外のLDAP情報を記入してください。バインドアカウント情報はcredentialsに記入してください。

下記コマンドでアセットファイルを事前コンパイルを行います。

```sh
RAILS_ENV=production bin/rails assets:precompile
```

データベースに専用のデータベースとユーザーを作成します。データベースのデフォルト接続先はlocalhostのMariaDBで、データベース名はikamailです。また、キャッシュ、キュー、ケーブル用に、ikamail_cache、ikamail_queue、ikamail_cabelが必要です。変更する場合は、環境変数`DATABASE_URL`、`CACHE_DATHABASE_URL`、`QUEUE_DATABASE_URL`、`CABLE_DATABASE`を設定してください。

```sql
CREATE USRE ikamail@'localhost' IDENTIFIERD BY 'DBユーザーのパスワード';
CREATE DATABASE ikamail;
CREATE DATABASE ikamail_cache;
CREATE DATABASE ikamail_queue;
CREATE DATABASE ikamail_cable;
GRANT ALL PRIVILEGES ON ikamail.* TO ikamail@'localhost';
GRANT ALL PRIVILEGES ON ikamail_cache.* TO ikamail@'localhost';
GRANT ALL PRIVILEGES ON ikamail_queue.* TO ikamail@'localhost';
GRANT ALL PRIVILEGES ON ikamail_cable.* TO ikamail@'localhost';
FLUSH PRIVILEGES;
```

データベースの準備ができたら、データベースをマイグレーションしてください。

```sh
RAILS_ENV=production bin/rails db:migrate
```

あとは、doc/scriptsにあるサンプルを参考にサービスに登録して、起動してください。jobsを有効にすることも忘れないでください。

定期的な処理はwheneverでクーロン登録ができます。

```sh
bundle exec whenever --update-crontab
```

登録情報の変更等は`config/schedule.rb`を書き換えてください。その他、`batch/cron`にもバッチ処理のシェルのサンプルがあります。
