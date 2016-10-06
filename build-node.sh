#!/bin/bash

cat >/etc/hosts <<EOF
127.0.0.1       localhost
192.168.50.5    chef-server.endocode.com    chef-server
192.168.50.6    chef-delivery.endocode.com  chef-delivery
192.168.50.7    build-node
EOF

hostname build-node

# Not really nice stuff but ...

sed -i.bak 's/^PermitRootLogin.*$/PermitRootLogin yes/' /etc/ssh/sshd_config

echo -e "toor\ntoor" | passwd root

# Some automatic shell scripts do not work with dash.
rm /bin/sh
ln -s /bin/bash /bin/sh

service ssh restart

