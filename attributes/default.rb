default['openvpn']['server_name'] = 'default'
default['openvpn']['default']['users'] = []
default['openvpn']['default']['revoked_users'] = []

# Network
default['openvpn']['default']['server_ip'] = '127.0.0.1'
default['openvpn']['default']['port'] = '1194'
default['openvpn']['default']['proto'] = 'udp'
default['openvpn']['default']['dev'] = 'tun'
default['openvpn']['default']['mode'] = 'routed'
default['openvpn']['default']['netmask'] = '255.255.255.0'
default['openvpn']['default']['remote_host'] = 'vpn.example.com'
default['openvpn']['default']['subnet'] = '127.0.0.0'
default['openvpn']['default']['network_bridge'] = 'br0'
default['openvpn']['default']['network_interface'] = 'eth0'
default['openvpn']['default']['dhcp_start'] = '127.0.0.100'
default['openvpn']['default']['dhcp_end'] = '127.0.0.150'
default['openvpn']['default']['link_mtu'] = '1400'

default['openvpn']['default']['push'] = []
default['openvpn']['default']['duplicate_cn'] = false
default['openvpn']['default']['client_to_client'] = false 
default['openvpn']['default']['keepalive_interval'] = 10
default['openvpn']['default']['keepalive_timeout'] = 60
default['openvpn']['default']['comp_lzo'] = true
default['openvpn']['default']['cipher'] = false
default['openvpn']['default']['redirect_gateway'] = false
default['openvpn']['default']['push_dns_server'] = false
default['openvpn']['default']['script_security'] = 1

#default['openvpn']['default'][''] = 
