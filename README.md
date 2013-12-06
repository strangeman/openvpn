openvpn Cookbook
================

So, why the world need another openvpn cookbook?

TODO
----------------

0. Docs
1. Revoke access
2. un-Hardcode plugin
3. Import existing certs/keys

USAGE
----------------

For example you want to setup vpn server and call it ```office```

* Ensure that you have ```.chef/encrypted_data_bag_secret```, otherwise you can generate one with ```openssl rand -base64 512 > .chef/encrypted_data_bag_secret```

* Install knife plugin into your project chef directory 

```
mkdir -p /path/to/your/project/.chef/plugins/knife
cp /path/to/this/openvpn/cookbook/knife_plugin.rb /path/to/your/project/.chef/plugins/knife/openvpn.rb
```

* Create server certificate authority, server cert/key, DH params

```
knife openvpn server create office
```

```producton``` - is a name of vpn-server, there is some limitations on this: no dots, no commas, no spaces, no special symbols for reasons

* Great, now check ```data_bags``` directory, you will find new databag ```openvpn-office``` with few items for ca, dh, server and ssl config. Now it is time to upload it to server

```
knife data bag create openvpn-office --secret-file=.chef/encrypted_data_bag_secret
knife data bag from file openvpn-office data_bags/openvpn-office/*
```

* OK, it is time for a server. Add ```recipe[openvpn]``` to node run_list, and override default attributes

```
  "run_list": [
    "recipe[openvpn]"
  ],
  "default_attributes": {
    "openvpn": {
      "server_name": "office",
      "office": {
        "server_ip": "10.90.5.5",
        "port": "443",
        "proto": "tcp"
  ....

```
Chef run! 

* When server is up and running we can add some users to start use it. No moar certificate management pain

```
knife openvpn user create office john
knife data bag from file openvpn-office data_bags/openvpn-office/john.json
```

* Export vpn-client data and send it to John

```
knife openvpn user export office john
```
resulting archive contains config (.ovpn), ca cert, John's cert and key






