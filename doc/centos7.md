# CentOS 7 インストール

## パッケージインストール

```
sudo yum install epel-release
sudo yum install centos-release-scl
sudo yum groupinstall "Development Tools"
```

```
sudo yum install git
sudo yum install vim
```


## Node.js と Yarn

```
sudo yum install rh-nodejs10
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo yum install yarn
```

## Ruby

```
sudo yum install rh-ruby26 rh-ruby26-ruby-devel rh-ruby26-rubygem-bundler
```

## MariaDB

serverは10.3だがクライアントはcompitableで

```
sudo yum install rh-mariadb103
```

sudo systemctl start rh-mariadb103-mariadb
sudo systemctl enable rh-mariadb103-mariadb

scl enable rh-mariadb102 -- bash

mysql_secure_installation

rootのパスワードはpassで

やはりコンパイルするしか無い
sudo yum install mariadb mariadb-devel


## その他

sudo yum install libxml2-devel


## テスト環境構築

### nginx

```
sudo yum install rh-nginx114
```

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
