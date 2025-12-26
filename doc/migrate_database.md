# データベース移行

0.8から1.0へのアップデートするときにデータベースの変更する方法

データベースの準備。

```sql
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

バックアップ。

```sh
mysqldump \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  --databases ikamail \
  > ikamail.sql
```

古いデータベースから新しいデータベースへのコピー。

```sh
mysqldump \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  --no-create-db \
  --databases ikamail \
  | sed -e 's/`ikamail`/`ikamail_production`/g' \
  | tee migrate_ikamail.sql \
  | mysql
```

この後に、migrationを実行し、テストを行い、問題なければ、古いデータベースを削除する。

```sql
DROP DATABASE ikamail;
```
