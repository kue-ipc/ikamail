#!/bin/sh

ldapadd -x -h localhost -p 3389 -D "cn=admin,dc=example,dc=jp" -w secret -f base.ldif
