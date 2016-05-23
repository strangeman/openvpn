#
# Cookbook Name:: openvpn
# Recipe:: iptables
#
# Copyright 2016, LLC Express 42
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

include_recipe 'iptables::default' if node['openvpn']['iptables']['postrouting']

require 'ipaddr'

server_name = node['openvpn']['server_name']
config = Chef::Mixin::DeepMerge.merge(node['openvpn']['default'].to_hash, node['openvpn'][server_name].to_hash)

iptables_rule 'openvpn_nat' do
  variables(
    subnet: config['subnet'],
    cidr: IPAddr.new(config['netmask']).to_i.to_s(2).count('1'),
    interface: node['openvpn']['iptables']['interface']
  )
  action :enable
  only_if { node['openvpn']['iptables']['postrouting'] }
end
