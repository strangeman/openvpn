include_recipe 'apt'

node.default['openvpn']['default']['mode'] = 'bridged'
node.default['openvpn']['default']['dev'] = 'tap'
node.default['openvpn']['default']['script_security'] = 2

package 'bridge-utils'

execute 'Add bridge network interface' do
  command 'brctl addbr br0'
  action :run
  not_if { node['network']['interfaces']['br0'] }
end

include_recipe 'openvpn'
