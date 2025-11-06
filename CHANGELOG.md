# 主な変更点

## 0.8 => 1.0

- データベースの設定が変更されました。
    - MariaDBへの接続はmysql2からtrilogyに変更されました。
    - データベースはcredentialsやSettingsでは設定できなくなりました。
- キャッシュ、Active Jobのキュー、Action CableのデフォルトがそれぞれSolid Cache、Solid Queue、Solid Cableに変更され、Redisが不要になりました。環境変数を指定することで、引き続きRedis(キューはResque)を使用することができます。

## 0.7 => 0.8

- Ruby 3.3 以上が必要になりました。
- Node.js 20 以上が必要になりました。
- Active JobのキューをDelayedJobからResqueに変更しました。
- Redisが必須になりました。

## 0.5 => 0.6

- Ruby 3.0 以上が必要になりました。
- Node.js 18 以上が必要になりました。
- TemlateモデルをMailTempaletモデルに名前を変更しました。
