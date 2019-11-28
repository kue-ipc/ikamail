# CentOS 7 インストール

## パッケージインストール

```
sudo yum install epel-release
sudo yum install centos-release-scl
```

## Node.js と Yarn

```
sudo yum install rh-nodejs10
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo yum install yarn
```

## Ruby

```
sudo yum install rh-ruby26
```

## MariaDB

```
sudo yum install rh-mariadb103
```

## テスト環境構築

### nginx

```
sudo yum install rh-nginx114
```

### ldap

```
sudo yum install openldap-servers
sudo cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
```




### postfix

```
sudo yum install postfix
```
