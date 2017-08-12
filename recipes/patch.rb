service 'jts' do
  action :stop
end

package "unzip"

directory "Create patch directory" do
  path "/opt/IBM/JazzTeamServer/server/patch"
  action :create
end

clm_fix = File.basename(node['clm']['fix'],File.extname(node['clm']['fix']))
major_version = node['clm']['version'].split('_')[0]

ark "#{clm_fix}" do
  url "https://depy.s3.amazonaws.com/clm/#{major_version}/#{node['clm']['fix']}"
  path "#{Chef::Config['file_cache_path']}/CLM_FIX"
  action :dump
  strip_components 0
  notifies :create, 'remote_file[Copy CLM server patch]', :immediately
end

remote_file "Copy CLM server patch" do 
  path "/opt/IBM/JazzTeamServer/server/patch/#{node['clm']['server_patch']}" 
  source "file://#{Chef::Config['file_cache_path']}/CLM_FIX/#{node['clm']['server_patch']}"
end

[ "temp", "work" ].each do |dir|
  Dir['/opt/IBM/JazzTeamServer/server/tomcat/#{dir}/*'].each do |path|
    file path do
      action :delete
    end
  end
end
  
[ "rs", "ldx", "lqe" ].each do |app|
 
  ["/opt/IBM/JazzTeamServer/server/liberty/servers/clm/apps","/opt/IBM/JazzTeamServer/server/liberty/clmServerTemplate/apps"].each do |path|
  
    remote_file "Copy #{app}.war" do
      path "#{path}/#{app}.war.zip" 
      source "file://#{Chef::Config['file_cache_path']}/CLM_FIX/#{app}.war"
      only_if { Dir.exist?("#{path}") }
    end
            
    ark "#{app}" do
      url "file://#{path}/#{app}.war.zip"
      path "#{path}"
      action :dump
      creates "#{path}/#{app}.war"
      only_if { Dir.exist?("#{path}") }
    end  
    
  end
  
end

Dir['/opt/IBM/JazzTeamServer/server/conf/dcc/mapping/*'].each do |path|
  file path do
    action :delete
    only_if { node['clm']['version'].to_s <  '6.0.3' and node['clm']['version'].to_s >=  '5.0.0'}
  end
end

remote_file "/opt/IBM/JazzTeamServer/server/conf/dcc/teamserver.properties.before" do
  source lazy { "file:///opt/IBM/JazzTeamServer/server/conf/dcc/teamserver.properties" }
  action :create
  only_if { node['clm']['version'].to_s >=  '6.0.3' }
end

java_properties '/opt/IBM/JazzTeamServer/server/conf/dcc/teamserver.properties' do
  properties_file '/opt/IBM/JazzTeamServer/server/conf/dcc/teamserver.properties'
  property 'com.ibm.rational.datacollection.initialized', 'false'
  only_if { node['clm']['version'].to_s >=  '6.0.3' }
end

remote_file "/opt/IBM/JazzTeamServer/server/conf/dcc/teamserver.properties.after" do
  source lazy { "file:///opt/IBM/JazzTeamServer/server/conf/dcc/teamserver.properties" }
  action :create
  only_if { node['clm']['version'].to_s >=  '6.0.3' }
end

file "/opt/IBM/JazzTeamServer/server/conf/dcc/wrapper/lib/com.ibm.rational.datacollection.wrapper_1.0.0.v20160805_1809.jar" do
  action :delete
  only_if { node['clm']['version'].to_s >=  '6.0.3' }
end

remote_file "/opt/IBM/JazzTeamServer/server/conf/dcc/wrapper/lib/com.ibm.rational.datacollection.wrapper_1.0.0.v20160805_1809.jar" do
  source lazy { "file://#{Chef::Config['file_cache_path']}/CLM_FIX/com.ibm.rational.datacollection.wrapper_1.0.0.v20160805_1809.jar" }
  action :create
  only_if { node['clm']['version'].to_s >=  '6.0.3' }
end

service 'jts' do
  action :start
end

execute 'Wait for jts service to start up before proceeding' do
  command 'sleep 60'
end
