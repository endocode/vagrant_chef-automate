#!/bin/bash

cat >/etc/hosts <<EOF
127.0.0.1       localhost
192.168.50.5    chef-server.endocode.com    chef-server
192.168.50.6    chef-delivery.endocode.com  chef-delivery
192.168.50.7    build-node
EOF

hostname chef-server

# Chef Server Installation

DEST="/vagrant"

wget -q https://packages.chef.io/stable/ubuntu/14.04/chef-server-core_12.9.1-1_amd64.deb
dpkg -i chef-server-core_12.9.1-1_amd64.deb

chef-server-ctl reconfigure

USER=johnd
FIRST_NAME=John
LAST_NAME=Doe
EMAIL_ADDRESS=johnd@endocode.com
PASSWORD=passw0rd
ORG=endocode
ORG_DESC='Endocode A.G'

chef-server-ctl user-create $USER $FIRST_NAME $LAST_NAME $EMAIL_ADDRESS "$PASSWORD" --filename $DEST/${USER}.pem
chef-server-ctl org-create $ORG "$ORG_DESC" -a $USER --filename $DEST/$ORG-validator.pem

# Push Jobs Server & Manage Installation

wget -q https://packages.chef.io/stable/ubuntu/14.04/opscode-push-jobs-server_1.1.6-1_amd64.deb

chef-server-ctl install chef-manage

chef-server-ctl install opscode-push-jobs-server --path /home/vagrant/opscode-push-jobs-server_1.1.6-1_amd64.deb

# Completing Setup

chef-server-ctl reconfigure
chef-manage-ctl reconfigure
opscode-push-jobs-server-ctl reconfigure

# Create a User and Organization to Manage Your Cluster

AUTO_CHEF_USER=delivery
AUTO_FIRST_NAME=Auto
AUTO_LAST_NAME=Chef
AUTO_EMAIL_ADDRESS="delivery@auto.chef"
AUTO_PASSWORD=delivery
AUTO_CHEF_ORG="chef_delivery"
AUTO_CHEF_ORG_DESC="Auto Chef Org"

chef-server-ctl user-create $AUTO_CHEF_USER $AUTO_FIRST_NAME $AUTO_LAST_NAME $AUTO_EMAIL_ADDRESS "$AUTO_PASSWORD" --filename $DEST/${AUTO_CHEF_USER}.pem
chef-server-ctl org-create $AUTO_CHEF_ORG "$AUTO_CHEF_ORG_DESC" -a $AUTO_CHEF_USER  --filename $DEST/${AUTO_CHEF_ORG}-validator.pem


