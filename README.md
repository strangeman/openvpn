openvpn Cookbook
================

So, why the world needs another openvpn cookbook?

TODO
----------------

1. Revoke access
2. un-Hardcode plugin
3. Import existing certs/keys

USAGE
----------------

For example you want to setup vpn server and call it ```office```

* Ensure that you have ```.chef/encrypted_data_bag_secret```. 
Otherwise you can generate one with ```openssl rand -base64 512 > .chef/encrypted_data_bag_secret```

* Install knife plugin into your project chef directory 

```
mkdir -p /path/to/your/project/.chef/plugins/knife
cp /path/to/this/openvpn/cookbook/knife_plugin.rb /path/to/your/project/.chef/plugins/knife/openvpn.rb
```

* Create server certificate authority, server cert/key, DH params

```
knife openvpn server create office
```

```office``` - is a name of vpn-server, there is some limitations on this: no dots, no commas, no spaces, no special symbols for reasons. 

* Great, now check ```data_bags``` directory, you will find new databag ```openvpn-office``` with few items for ca, dh, cert/key pair and some openssl config. Now it is time to upload it to Chef server

```
knife data bag create openvpn-office --secret-file=.chef/encrypted_data_bag_secret
knife data bag from file openvpn-office data_bags/openvpn-office/*
```

* Add ```recipe[openvpn]``` to node run_list, and override default attributes

```
  "run_list": [
    "recipe[openvpn]"
  ],
  "default_attributes": {
    "openvpn": {
      "server_name": "office",
      "office": {
        "remote_host": "vpn.example.com",
        "server_ip": "10.90.5.5",
        "subnet": "10.200.1.0",
        "port": "443",
        "proto": "tcp",
        "dev": "tun",
        "verb": "3",
        "push": [
          "route 10.90.0.0 255.255.255.0",
          "route 10.90.1.0 255.255.255.0"
        ]
      }
    }
  }

```
Chef, run! 

* When server is up and running we can add some users to start use it. 
No moar certificate management pain

```
knife openvpn user create office john
knife data bag from file openvpn-office data_bags/openvpn-office/john.json
```

* Export vpn-client data and send it to John

```
knife openvpn user export office john
```
resulting archive contains config (.ovpn), ca cert, John's cert and key

Server Modes
-------------

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
        "network_interface": "eth0",
        "script_security": "2"
      }
    }
  }

``` 

Attributes
-------------

For default values see attributes/default.rb

```server_name``` - Name of openvpn server. Use node['openvpn'][server_name] hash for configs
```remote_host``` - This address will be used for clients config as vpn server address
```server_ip``` - server is accepting connections on this IP
```netmask``` - netmask to use (for routed and bridged modes)
```port``` - network port to listen on
```proto``` - protocol to use (tcp or udp)
```mode``` - OpenVPN can work in two modes: routed and bridged. See OpenVPN docs at https://community.openvpn.net/openvpn/wiki/BridgingAndRouting 
```dev``` - type of dev to use (tun or tap).
```subnet``` - only for routed mode. This subnet is used for vpn client addresses. Server takes first address in this net

```network_bridge``` - only in bridged mode. OpenVPN tap interface will be added to this bridge (see up/down scripts)
```network_interface``` - only in bridged mode. Network interface used for bridging, we need to turn promisc mode for it
```dhcp_start```/```dhcp_end``` - only in bridged mode. Assign client addresses from this range
```script_security``` - set it to "2" for bridged mode to allow script execution needed to configure network interfaces

```push``` - array of route strings that will be pushed on client connect

```client_to_client``` - true\false. Allow clients talk to each other
```comp_lzo``` - true\false. Use compression
```redirect_gateway``` - true\false. Send all traffic through vpn channel

