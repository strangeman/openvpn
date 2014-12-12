name             'openvpn'
maintainer       'LLC Express 42'
maintainer_email 'cookbooks@express42.com'
license          'MIT'
description      'Installs and configures OpenVPN.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.2'

recipe           'openvpn::default', 'Installs and configures OpenVPN.'

supports         'ubuntu'
