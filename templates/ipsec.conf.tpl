config setup
        charondebug="all"
        strictcrlpolicy=no
        uniqueids=never
        cachecrls=no

conn ikev2-pubkey 
      auto=add
      compress=no
      type=tunnel
      keyexchange=ikev2
      fragmentation=yes
      forceencaps=yes
      dpdaction=clear
      dpddelay=300s
      rekey=no
      left=%any
      leftid="CN=server.vpn.com"
      leftcert=server.crt
      leftsendcert=always
      leftsubnet=${left_subnet}
      right=%any
      rightid=%any
      rightauth=eap-tls
      rightsourceip=${vpn_subnet}
      rightsendcert=never