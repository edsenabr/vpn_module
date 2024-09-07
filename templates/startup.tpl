#!/bin/bash
env DEBIAN_FRONTEND=noninteractive \
      apt install \
            -y \
            -o Dpkg::Options::="--force-confdef" \
            -o Dpkg::Options::="--force-confold" \
            --force-yes \
            strongswan \
            libcharon-extra-plugins \
#            iptables-persistent

gsutil cp ${bucket}/ipsec.conf /etc/ipsec.conf
#gsutil cp ${bucket}/rules.v4 /etc/iptables/rules.v4
gsutil cp ${bucket}/ca.crt /etc/ipsec.d/cacerts/ca.crt
gsutil cp ${bucket}/server.crt /etc/ipsec.d/certs/server.crt
gsutil cp ${bucket}/ca.key /etc/ipsec.d/private/ca.key
gsutil cp ${bucket}/server.key /etc/ipsec.d/private/server.key

cat <<EOF >>/etc/ipsec.secrets
: RSA server.key
EOF

cat <<EOF >>/etc/sysctl.conf
net.ipv4.ip_forward = 1 
net.ipv6.conf.all.forwarding = 1 
net.ipv4.conf.all.accept_redirects = 0 
net.ipv4.conf.all.send_redirects = 0 
EOF

sysctl -p

#iptables-restore < /etc/iptables/rules.v4

systemctl enable strongswan-starter.service
systemctl restart strongswan-starter.service