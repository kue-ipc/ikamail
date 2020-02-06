# CentOS 7 インストール

このファイルはメモです。メンテナンスされていない場合があります。

## パッケージインストール

### 全体

```
sudo yum install git
sudo yum install vim
```

```
sudo yum install epel-release
sudo yum install centos-release-scl
sudo yum groupinstall "Development Tools"
```

### Node.js と Yarn

```
sudo yum install rh-nodejs10
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo yum install yarn
```

### Ruby

```
sudo yum install rh-ruby26 rh-ruby26-ruby-devel rh-ruby26-rubygem-bundler
```

### MariaDB

serverは10.3だがクライアントはcompitableなデフォルトのバージョンで行う。

```
sudo yum install rh-mariadb103
sudo yum install mariadb-devel
```

```
sudo systemctl start rh-mariadb103-mariadb
sudo systemctl enable rh-mariadb103-mariadb
sudo scl enable rh-mariadb103 -- bash
mysql_secure_installation
```

rootのパスワードを設定すること


```/etc/opt/rh/rh-mariadb103/my.cnf.d/
[client]
default-character-set = utf8mb4

[server]
character-set-server = utf8mb4
```

```/etc/my.cnf.d/defult.cnf
[client]
default-character-set = utf8mb4

[server]
character-set-server = utf8mb4
```

utf8mb4が使用されているかどうかは`show variables like 'char%';`で確認する。

### その他

```
sudo yum install libxml2-devel
```

## 環境構築

```
scl enable rh-nodejs10 rh-ruby26 -- bash
```

クローン

```
git clone ...
cd ikamail
bundle install --deployment --without development test
bundle exec rails yarn:install
RAILS_ENV=production bundle exec rails assets:precompile
```

```
EDITOR=vim bundle exec rails credentials:edit
```

```credentials
secret_key_base: 自動生成されるキー
database:
  password: データベースのikamailのパスワード
ldap:
  password: LDAPプロキシエージェントの設定
```

mysql -h localhost -u root -p
```
create database ikamail;
create user ikamail@'localhost' identified by 'dbpass';
grant all privileges on ikamail.* to ikamail@'localhost';
flush privileges;
```

データベースのマイグレーション

```
RAILS_ENV=production bundle exec rails db:migrate
```

テスト
```
RAILS_ENV=production bundle exec rails server
```

クーロン登録
```
bundle exec whenever --update-crontab
```

ただし、sclが反映されないため、`/bin/scl enable rh-nodejs10 rh-ruby26 -- `を付ける必要がある。

```実行
bundle exec rails server
```

```終了
kill `cat tmp/pids/puma.pid`
```

```ジョブ
bundle exec bin/delayed_job -n 2 start
bundle exec bin/delayed_job -n 2 stop
```

リバースプロキシ等は下記のテスト環境構築を参考に適当に設定すること。

なお、Apacheは2.4.6のためUNIXドメインソケット経由でのリバースプロキシに未対応なので注意。

## テスト環境構築(参考)

これはメール送信まで可能なテスト環境を構築するための方法について記載したものです。各設定はサーバーによって大きく異なるため、本番環境では下記内容をそのまま設定してはいけません。内容を理解の上に参考情報としてお使いください。

### nginx

```
sudo yum install rh-nginx114
```
systemctl status rh-nginx114-nginx

```
http {
    upstream ikamail {
        server unix:/opt/app/ikamail/tmp/sockets/puma.sock
    }
    server {
        location / {
            proxy_path http://ikamail;
            proxy_redirect off;
            proxy_set_header Host $http_host;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
}
```

/opt/app/ikamail/tmp/sockets/puma.sock
はsclで制限有り。
/opt/app/ikamail/

### ldap

```
sudo yum install openldap-servers
sudo yum install openldap-clients
sudo cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
```

```
sudo vim "/etc/openldap/slapd.d/cn=config/olcDatabase={1}monitor.ldif"
sudo vim "/etc/openldap/slapd.d/cn=config/olcDatabase={2}hdb.ldif"
```

olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=extern
 al,cn=auth" read by dn.base="cn=admin,dc=example,dc=jp" read by * none

olcRootDN: cn=admin,dc=example,dc=jp
olcRootPW: `slappasswd -s secret`


{SSHA}d1ZX0M+LVJdbEjG1S+XNw3AFoB/mwGxx

cn=Manager,dc=my-domain,dc=com -> cn=admin,dc=example,dc=jp

ldap

```
sudo ldapadd -H ldapi:/// -Y EXTERNAL -f /etc/openldap/schema/cosine.ldif
sudo ldapadd -H ldapi:/// -Y EXTERNAL -f /etc/openldap/schema/inetorgperson.ldif
sudo ldapadd -H ldapi:/// -Y EXTERNAL -f /etc/openldap/schema/nis.ldif
```


ldapadd -x -h localhost -D "cn=admin,dc=example,dc=jp" -w secret -f base.ldif

ldapadd -x -h localhost -D "cn=admin,dc=example,dc=jp" -w secret -f base.ldif

 ldapsearch -x -h localhost -D "cn=admin,dc=example,dc=jp" -w secret -b "ou=Users,dc=example,dc=jp" "(mail=admin@example.jp)"

### postfix

```
sudo yum install postfix
```

```main.cf
virtual_mailbox_domains = example.jp
virtual_mailbox_base = /var/mail/virtual
virtual_mailbox_maps = ldap:/etc/postfix/ldap-mailbox.cf
virtual_uid_maps = static:1000
virutal_gid_maps = static:1000
```


```ldap-mailbox.cf
server_host = 127.0.0.1
search_base = ou=Users,dc=example,dc=jp
scope = sub
bind = yes
bind_dn = cn=admin,dc=example,dc=jp
query_filter = (mail=%s)
bind_pw = secret
result_attribute = uid
result_format = %s
```

## scl

scl enable rh-nodejs10 rh-ruby26 -- bash

git clone ...
cd ikamail
bundle install --deployment

EDITOR=vim bundle exec rails credentials:edit

bash
export RAILS_ENV=production
export IKAMAIL_DATABASE_PASSWORD=dbpass

EDITOR=vim bundle exec rails credentials:edit


bundle exec rails yarn:install
bundle exec rails assets:precompile

mysql -h localhost -u root -p
```
create database ikamail;
create user ikamail@'localhost' identified by 'dbpass';
grant all privileges on ikamail.* to ikamail@'localhost';
flush privileges;
```

bundle exec rails db:migrate

実行
bundle exec rails server

終了
kill `cat tmp/pids/puma.pid`

ジョブ
bundle exec bin/delayed_job -n 2 start
bundle exec bin/delayed_job stop
