# インストール

## 準備

Ruby、Node.jsをインストールします。Node.jsインストール後に、Yarnもインストールします。`ruby`、`node`、`yarn`のコマンドがアプリケーションを実行するユーザーで実行できることを確認します。

## アプリインストール

アプリケーションを実行するユーザーでインストールを行います。

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

## 各設定

環境変数、credentials、settingsで行います。優先順位は、環境変数 > credentials > settings > ファイル です。また、URLが設定されいる場合は、URLで設定されている値が優先されます。

通常は、下記コマンドでcredentials情報("config/master.key"と"config/credentials.yml.enc")を作成し、config/credenstials.yml.sampleを参考に設定してください。編集する場合も同じコマンドで可能です。

```sh
EDITOR=vi bin/rails credentials:edit
```

認証情報以外はsettgisを作成して設定してください。

```sh
vi config/settings.local.yml
```

その他の項目も環境変数で設定することも可能です。"config/master.key"は漏洩しないように注意してください。ファイルではなく、環境変数`RAILS_MASTER_KEY`で渡すようにすることもできます。

### 秘密鍵

マスター鍵はcredentialsの暗号化に使用します。ベース鍵はアプリケーション全体での暗号化等に使用されます。credentials生成時にランダムな値が自動的に設定されますが、環境変数で指定することも可能です。

|名前      |デフォルト値|環境変数        |credentials    |settings|ファイル         |
|----------|------------|----------------|---------------|--------|-----------------|
|マスター鍵|(無し)      |RAILS_MASTER_KEY|               |        |config/master.key|
|ベース鍵  |(無し)      |SECRET_KEY_BASE |secret_key_base|        |                 |

### データベース

メインで使用するデータベース(プライマリーデータベース)は下記のように設定できます。

|名前        |デフォルト値      |環境変数                 |credentials       |settings         |
|------------|------------------|-------------------------|------------------|-----------------|
|URL         |(無し)            |DATABASE_URL             |                  |                 |
|アダプター  |trilogy           |RALIS_DATABASE_ADAPTER   |                  |database.adapter |
|ホスト      |localhost         |DB_HOST                  |                  |database.host    |
|データベース|ikamail_production|                         |                  |database.database|
|ユーザー名  |ikamail           |                         |database.usnername|                 |
|パスワード  |(無し)            |IKAMAIL_DATABASE_PASSWORD|database.password |                 |

URLかパスワードのいずれかが必須です。指定できるアダプター(URLのスキーム)はtrilogy、mysql2、mysql(mysql2)、postgresql、postgres(postgresql)、sqlite3、sqlite(sqlite3)です。ポート番号やオプションを指定したい場合はURLで設定してください。

Solid Cache、Solid Queue、Solid Cableで使用するデータベースもそれぞれ設定できます。デフォルトではプライマリーデータベースにサフィックスが追加されます。その他項目はプライマリーデータベースと同じになります。

|名前              |デフォルト値                    |環境変数          |credentials|settings               |
|------------------|--------------------------------|------------------|-----------|-----------------------|
|cache URL         |(無し)                          |CACHE_DATABASE_URL|           |                       |
|queue URL         |(無し)                          |QUEUE_DATABASE_URL|           |                       |
|cable URL         |(無し)                          |CABLE_DATABASE_URL|           |                       |
|cache データベース|{プライマリーデータベース}_cache|                  |           |database.cache_database|
|queue データベース|{プライマリーデータベース}_queue|                  |           |database.queue_database|
|cable データベース|{プライマリーデータベース}_cable|                  |           |database.cable_database|

### LDAP

|名前        |デフォルト値|環境変数|credentials  |settings     |
|------------|------------|--------|-------------|-------------|
|URL         |(無し)      |LDAP_URL|             |             |
|プロトコル  |ldap        |        |             |ldap.protocol|
|ホスト      |localhost   |        |             |ldap.host    |
|ポート番号  |(無し)      |        |             |ldap.port    |
|ベースDN    |(無し)      |        |             |ldap.base    |
|バインドDN  |(無し)      |        |ldap.username|             |
|パスワード  |(無し)      |        |ldap.password|             |

ベースDNは必須です。指定できるプロトコル(URLのスキーム)はldapとldapsです。ホストがlocalhost以外でプロトコルがldapの場合はSTARTTLSが必須になります。ポート番号を指定しない場合は、プロトコルのデフォルトです。バインドDNがない場合、匿名でバインドします。

## アセットファイル

下記コマンドでアセットファイルを事前コンパイルを行います。

```sh
SECRET_KEY_BASE_DUMMY=1 RAILS_ENV=production bin/rails assets:precompile
```

## データベースの用意

データベースに専用のデータベースとユーザーを作成します。データベースのデフォルト接続先はlocalhostのMariaDBで、データベース名はikamailです。また、キャッシュ、キュー、ケーブル用に、ikamail_cache、ikamail_queue、ikamail_cabelが必要です。変更する場合は、環境変数`DATABASE_URL`、`CACHE_DATHABASE_URL`、`QUEUE_DATABASE_URL`、`CABLE_DATABASE`を設定してください。

```sql
CREATE USRE ikamail@'localhost' IDENTIFIERD BY 'DBユーザーのパスワード';
CREATE DATABASE ikamail_production;
CREATE DATABASE ikamail_production_cache;
CREATE DATABASE ikamail_production_queue;
CREATE DATABASE ikamail_production_cable;
GRANT ALL PRIVILEGES ON ikamail_production.* TO ikamail@'localhost';
GRANT ALL PRIVILEGES ON ikamail_production_cache.* TO ikamail@'localhost';
GRANT ALL PRIVILEGES ON ikamail_production_queue.* TO ikamail@'localhost';
GRANT ALL PRIVILEGES ON ikamail_production_cable.* TO ikamail@'localhost';
FLUSH PRIVILEGES;
```

データベースの準備ができたら、データベースをマイグレーションしてください。

```sh
RAILS_ENV=production bin/rails db:migrate
```

## サービスの実行

doc/etcにあるサンプルを参考にサービスに登録して、起動してください。

- ikamail.service ... Rails本体
- ikamail-jobs.service ... ジョブ実行

定期的な処理はwheneverでクーロン登録ができます。

```sh
bundle exec whenever --update-crontab
```

登録情報の変更等は`config/schedule.rb`を書き換えてください。その他、`batch/cron`にもバッチ処理のシェルのサンプルがあります。

## その他のオプション

### 別のデータベース

データベース設定のアダプターを変更することで、PostgreSQLとSQLite3も使用可能です。ただし、十分なテストは実施していません。不具合がある場合は、Issuesに報告してください。

### Redisの使用

デフォルトはSolid Cache、Solid Queue、Solid Cableを使用しますが、代わりにRedis(Resque)を使用することもできます。

bundleでsolidグループを無効化し、redisグループを有効にします。

```sh
bundle config set --local with 'redis'
bundle config set --local without 'solid development test'
bundle install
```

次の環境変数またはSettingsで"redis"と設定(環境変数が優先)することで、Solidシリーズの代わりにRedis(Resque)を使用するようになります。

|名前                  |デフォルト値|環境変数                |credentials|settings          |
|----------------------|------------|------------------------|-----------|------------------|
|インメモリデータベース|solid       |RAILS_DATABASE_IN_MEMORY|           |database.in_memory|
