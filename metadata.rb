name             'openvpn'
maintainer       'LLC Express 42'
maintainer_email 'cookbooks@express42.com'
license          'MIT'
description      'Installs and configures OpenVPN.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.3'

recipe           'openvpn::default', 'Installs and configures OpenVPN.'

%w( ubuntu debian redhat centos fedora scientific amazon ).each do |os|
  supports os
end

depends 'yum-epel'
