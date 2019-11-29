# CentOS 7 インストール

## パッケージインストール

```
sudo yum install epel-release
sudo yum install centos-release-scl
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



### postfix

```
sudo yum install postfix
```
