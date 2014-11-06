#
# Cookbook Name:: openvpn
# Recipe:: default
#
# Copyright 2013, LLC Express 42
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

package "openvpn"

server_name = node['openvpn']['server_name']
config = Chef::Mixin::DeepMerge.merge(node['openvpn']['default'].to_hash, node['openvpn'][server_name].to_hash)
server_mode = config['mode']

if server_mode == "bridged"
  package "bridge-utils"
end

user "openvpn"
group "openvpn" do
  members ["openvpn"]
end

directory "/etc/openvpn/#{server_name}" do
  owner "root"
  group "openvpn"
  mode 00770
end

directory "/etc/openvpn/#{server_name}/keys" do
  owner "root"
  group "openvpn"
  mode 00770
end

directory "/var/log/openvpn" do
  owner "root"
  group "root"
  mode 00755
end

dh_item = Chef::EncryptedDataBagItem.load("openvpn-#{server_name}", "openvpn-dh")
ca_item = Chef::EncryptedDataBagItem.load("openvpn-#{server_name}", "openvpn-ca")
crl_item = Chef::EncryptedDataBagItem.load("openvpn-#{server_name}", "openvpn-crl")
server_item = Chef::EncryptedDataBagItem.load("openvpn-#{server_name}", "openvpn-server")

files = {
 'ca.crt' => ca_item["cert"],
 'dh.pem' => dh_item["dh"],
 'crl.pem' => crl_item["crl"],
 'server.crt' => server_item["cert"],
 'server.key' => server_item["key"]
}

files.each do |name, content|
  file "/etc/openvpn/#{server_name}/keys/#{name}" do
    owner "openvpn"
    group "openvpn"
    mode "0600"
    action :create_if_missing
    content content
  end
end

service "openvpn" do
  action [:enable]
end

template "/etc/openvpn/#{server_name}.conf" do
  source "server.conf.erb"
  variables :server_name => server_name, :config => config
  owner "root"
  group "openvpn"
  mode 00640
  notifies :restart, "service[openvpn]", :delayed
end

if server_mode == "bridged"
  template "/etc/openvpn/up.sh" do
    source "up.sh.erb"
    owner "root"
    group "openvpn"
    mode 00740
    notifies :restart, "service[openvpn]", :delayed
  end

  template "/etc/openvpn/down.sh" do
    source "down.sh.erb"
    owner "root"
    group "openvpn"
    mode 00740
    notifies :restart, "service[openvpn]", :delayed
  end
end

service "openvpn" do
  action [:start]
end
