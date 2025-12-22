# アップデート

## 基本

### リビジョンアップデート

ブランチでバージョンを固定している場合は、そのまま`git pull`してください。タグを指定している場合は、新しいリビジョンのタグに切り替えてください。

```sh
git pull
bundle install
bin/rails yarn:install
RAILS_ENV=production bin/rails db:migrate
RAILS_ENV=production bin/rails assets:precompile
```

### マイナーバージョンアップデート

Ruby、Node.js、データベースのバージョンをアップデートするバージョンで対応するバージョンにアップデートしておきます。

現在のバージョンを最新のリビジョンにしてから、ブランチを切り替えてアップデートしてください。メジャーバージョンが同じであれば、間のバージョンを飛ばすことができます。

アップデート前に、下記に書いてある個別の注意事項を確認してください。

```sh
git pull
bundle install
bin/rails db:migrate
git checkout __new_minor_version_branch__
git pull
bundle install
bin/rails yarn:install
RAILS_ENV=production bin/rails db:migrate
RAILS_ENV=production bin/rails assets:precompile
```

### メジャーバージョンアップデート

Ruby、Node.js、データベースのバージョンをアップデートするバージョンで対応するバージョンにアップデートしておきます。

メジャーバージョンは一つずつ上げる必要があります。一つ前のバージョンの最新のマイナーバージョンの最新のリビジョンからのアップデートのみサポートします。

アップデート前に、下記に書いてある個別の注意事項を確認してください。個別に必要な項目があれば、対応しておいてください。

```sh
git pull
bundle install
bin/rails db:migrate
git checkout __last_minor_version_branch__
git pull
bundle install
bin/rails db:migrate
git checkout __new_major_version_branch__
git pull
bundle install
bin/rails yarn:install
RAILS_ENV=production bin/rails db:migrate
RAILS_ENV=production bin/rails assets:precompile
```

## 個別の注意事項

### 0.x => 1.x

* ジョブの管理に互換性がなくなるため、スケジュールされたジョブは実行されません。予約済みのメールがある場合は、アップデート後に一旦中止し、再度配信を予約してください。
* データベースとLDAPの接続認証情報(ユーザー名とパスワード)をSettingsで設定できなくなりました。credentials、または、環境変数を使用してください。
* データベースのアダプターがtrilogyに変更されました。mysql2のgemは読み込まれなくなるため、`DATABASE_URL`でmysql2をしていている場合はエラーになります。trilogyに変更してください。
* データベースのデフォルトの名前が`ikamail`から`ikamail_production`に変更されました。以前と同じ名前にしたい場合は、Settingsで`database: {database: "ikamail"}}`と設定してください。
* キャッシュ、Active Jobのキュー、Action CableのデフォルトがそれぞれSolid Cache、Solid Queue、Solid Cableに変更されました。引き続きRedis(キューはResque)を使用することも可能です。下記のいずれかを実施してください。
    * Solidシリーズを使用する場合は、下記のようにデータベースを作成してから`bin/rails db:migrate`を実行してください。`ikamail_production`はメインとデータベース名で、そこにサフィックスが付きます。以前と同じ`ikamil`にしている場合は、それぞれ、`ikamail_cache`、`ikamail_queue`、`ikamail_cable`になります。

        ```sql
        CREATE DATABASE ikamail_production_cache;
        CREATE DATABASE ikamail_production_queue;
        CREATE DATABASE ikamail_production_cable;
        GRANT ALL PRIVILEGES ON ikamail_production_cache.* TO ikamail@'localhost';
        GRANT ALL PRIVILEGES ON ikamail_production_queue.* TO ikamail@'localhost';
        GRANT ALL PRIVILEGES ON ikamail_production_cable.* TO ikamail@'localhost';
        FLUSH PRIVILEGES;
        ```

    * Redis(キューはResque)を使用する場合は、下記のように環境変数を設定してください。

        ```env
        RAILS_CACHE_STORE=redis
        RAILS_QUEUE_ADAPTER=resque
        RAILS_CABLE_ADAPTER=redis
        ```

        `bundle install`の前にredisグループとresqueグループを読み込むようにしてください。

        ```sh
        bundle config set --local with 'redis resque'
        ```

        この場合でも、キャッシュやキューの互換性が保証できないため、Railsの起動前にRedis内のすべてのデータを削除しておいてください。

        ```sh
        $ redis-cli
        127.0.0.1:6379> flushall
        ```

### 0.7 => 0.8

* ジョブの管理に互換性がなくなるため、スケジュールされたジョブは実行されません。予約済みのメールがある場合は、アップデート後に一旦中止し、再度配信を予約してください。
* Redisが必須になりました。Redisをインストールし、起動しておいてください。
