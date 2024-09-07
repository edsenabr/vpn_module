[connection]
id=VPN
uuid=${vpn_uuid}
type=vpn
autoconnect=false
permissions=user:${user}:;

[vpn]
address=34.29.66.36
cert-source=file
certificate=${ca_cert}
encap=no
ipcomp=no
method=eap-tls
password-flags=2
proposal=no
remote-identity=CN=server.vpn.com
usercert=${client_cert}
userkey=${client_key}
virtual=yes
service-type=org.freedesktop.NetworkManager.strongswan

[ipv4]
method=auto

[ipv6]
addr-gen-mode=default
method=disabled

[proxy]