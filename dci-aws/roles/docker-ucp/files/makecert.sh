#!/bin/sh
openssl req -nodes -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 3650 -subj "/C=US/ST=Somewhere/L=Anywhere/O=Computer/CN=*.dogvscat.biz" -config openssl.cnf
# cat cert.crt key.key > full.pem
cp cert.pem ca.pem
