# アップデート

## 基本

### リビジョンアップデート

ブランチでバージョンを固定している場合は、そのまま`git pull`してください。タグを指定している場合は、新しいリビジョンのタグに切り替えてください。

```sh
git pull
bundle install
bin/rails db:migrate
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
RAILS_ENV=production bin/rails assets:precompile
bin/rails db:migrate
```

### メジャーバージョンアップデート

Ruby、Node.js、データベースのバージョンをアップデートするバージョンで対応するバージョンにアップデートしておきます。

メジャーバージョンは一つずつ上げる必要があります。一つ前のバージョンの最新のマイナーバージョンの最新のリビジョンからのアップデートのみサポートします。

アップデート前に、下記に書いてある個別の注意事項を確認してください。

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
RAILS_ENV=production bin/rails assets:precompile
```

設定変更等が必要な場合はこのときに実施してください。

```sh
bin/rails db:migrate
```

## 個別の注意事項

### 0.x => 1.x

* ジョブの管理に互換性がなくなるため、スケジュールされたジョブは実行されません。予約済みのメールがある場合は、アップデート後に一旦中止し、再度配信を予約してください。
* デフォルトのデーターベース名が`ikamail`から`ikamail_production`に変更されました。データベース名を変更する、または、下記のように環境変数を設定してください。

    ```sh
    DATABASE_URL=trilogy://ikamail@localhost/ikamail
    ```

* キャッシュ、Active Jobのキュー、Action CableのデフォルトがそれぞれSolid Cache、Solid Queue、Solid Cableに変更されました。`bin/rails `次のデータベースを作成しておく必要があります。
    * Solid Cache: `ikamail_production_cache`
    * Solid Queue: `ikamail_production_queue`
    * Solid Cable: `ikamail_production_cable`
    ただし、環境変数で、キャッシュ、Active Jobのキュー、Action CableについてRedis(キューはResque)を使用するように設定した場合は不要です。
* データベースはcredentialsやSettingsでは設定できなくなりました。データベースの接続情報は環境変数で指定してください。

### 0.7以下 => 0.8

* ジョブの管理に互換性がなくなるため、スケジュールされたジョブは実行されません。予約済みのメールがある場合は、アップデート後に一旦中止し、再度配信を予約してください。
* Redisが必須になりました。Redisをインストールし、起動しておいてください。
