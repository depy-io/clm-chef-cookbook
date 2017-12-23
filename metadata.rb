name             'clm'
maintainer       'Liora Milbaum'
maintainer_email 'liora@lmb.co.il'
license          'Apache v2.0'
description      'IBM Collaborative Lifecycle Management'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'
chef_version     '>= 12.1' if respond_to?(:chef_version)
issues_url       'https://github.com/depy-io/clm-chef-cookbook/issues'
source_url       'https://github.com/depy-io/clm-chef-cookbook'

depends 'poise-archive',   '~> 1.4.0'
depends 'depy-iim',        '~> 0.0.1'
depends 'java_properties', '~> 0.1.3'
depends 'ark',             '~> 2.2.1'

%w[ ubuntu ].each do |os|
  supports os
end
