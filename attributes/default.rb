require 'json'

if File.exist?(File.dirname(File.expand_path(__FILE__)) + '/../features.json')
  file = File.read(File.dirname(File.expand_path(__FILE__)) + '/../features.json')  
  default.merge! JSON.parse(file)
elsif File.exist?('/tmp/kitchen/data/features.json')
  file = File.read('/tmp/kitchen/data/features.json')  
  default.merge! JSON.parse(file)
end 

if File.exist?(File.dirname(File.expand_path(__FILE__)) + '/../infra.json')
  file = File.read(File.dirname(File.expand_path(__FILE__)) + '/../infra.json')  
  default.merge! JSON.parse(file)
elsif File.exist?('/tmp/kitchen/data/infra.json')
  file = File.read('/tmp/kitchen/data/infra.json')  
  default.merge! JSON.parse(file)
end

if File.exist?(File.dirname(File.expand_path(__FILE__)) + '/../env.json')
  file = File.read(File.dirname(File.expand_path(__FILE__)) + '/../env.json')  
  default.merge! JSON.parse(file) 
elsif File.exist?('/tmp/kitchen/data/env.json')
  file = File.read('/tmp/kitchen/data/env.json')  
  default.merge! JSON.parse(file)
end

default['clm']['clm_zip'] = nil
default['clm']['clm_fix'] = nil
default['clm']['clm_packages'] = nil
default['clm']['clm_server_patch'] = nil
default['clm']['build_zip'] = nil
default['clm']['build_packages'] = nil
default['clm']['rdm_zip'] = nil
default['clm']['rdm_fix'] = nil
default['clm']['RhapsodyModelServer_fix'] = nil
default['clm']['RhapsodyModelServer_linux_fix'] = nil 
default['clm']['rdm_packages'] = nil
default['clm']['activation_key'] = 'dabbad00-8872-36d4-b246-ca785dd63fde'
default['clm']['server_hostname'] = nil
default['clm']['engineId'] = "jke.dev.engine"