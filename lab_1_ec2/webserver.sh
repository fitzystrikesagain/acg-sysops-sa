#!/bin/bash

yum update -y
yum install -y httpd
yum install -y curl
chkconfig httpd on
service httpd start