#!/bin/bash

# Configure hostnames

cat >/etc/hosts <<EOF
127.0.0.1       localhost
192.168.50.5    chef-server.endocode.com    chef-server
192.168.50.6    chef-delivery.endocode.com  chef-delivery
192.168.50.7    build-node
EOF

hostname chef-delivery

# Chef Automate Server Installation and Configuration

wget -q https://packages.chef.io/stable/ubuntu/14.04/delivery_0.5.346-1_amd64.deb
dpkg -i delivery_0.5.346-1_amd64.deb

AUTOMATE_LICENSE="/vagrant/delivery.license"
AUTOMATE_CHEF_USER_KEY="/vagrant/delivery.pem"
CHEF_SERVER_FQDN="chef-server.endocode.com"
AUTOMATE_CHEF_ORG="chef_delivery"
AUTOMATE_SERVER_FQDN="chef-delivery.endocode.com"
ENTERPRISE_NAME="chef_auto_ent"

delivery-ctl setup --license $AUTOMATE_LICENSE \
                   --key $AUTOMATE_CHEF_USER_KEY \
                   --server-url https://$CHEF_SERVER_FQDN/organizations/$AUTOMATE_CHEF_ORG \
                   --fqdn $AUTOMATE_SERVER_FQDN \
                   --configure \
                   --no-build-node

delivery-ctl create-enterprise $ENTERPRISE_NAME --ssh-pub-key-file=/etc/delivery/builder_key.pub

# Set up a Build node

BUILD_NODE_FQDN=build-node
SSH_USERNAME=root
SSH_PASSWORD="toor"
SSH_IDENTITY_FILE="/vagrant/id_file" 
SSH_PORT=22

wget -q https://packages.chef.io/stable/ubuntu/12.04/chefdk_0.18.30-1_amd64.deb
delivery-ctl install-build-node --fqdn $BUILD_NODE_FQDN \
                                --username $SSH_USERNAME \
                                --password $SSH_PASSWORD \
                                --installer /home/vagrant/chefdk_0.18.30-1_amd64.deb \
#                                --ssh-identity-file $SSH_IDENTITY_FILE \
                                --port $SSH_PORT
