# Server Modes

* Routed

For routed network you must define vpn ```subnet```, like in previous example

* Bridged

Bridged setup need more configuration and configured network bridge on your server

```
"default_attributes": {
  "openvpn": {
    "server_name": "office",
    "office": {
      "remote_host": "vpn.example.com",
      "server_ip": "10.90.5.5",
      "port": "443",
      "proto": "tcp",
      "dev": "tap",
      "verb": "3",
      "mode": "bridged",
      "script_security": "2",
      "dhcp_start": "10.90.5.100",
      "dhcp_end": "10.90.5.240",
      "network_bridge": "br0",
      "network_interface": "eth0"
    }
  }
}

```

See fixture cookbook in `tests/fixtures/cookbooks`.
