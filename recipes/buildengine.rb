include_recipe "depy-iim"

major_version = node['clm']['version'].split('_')[0]

clm_servers = search(:node,'name:clm-server')

node.override['clm']['server_hostname']	= clm_servers[0]['ec2']['public_hostname']

cookbook_file 'clm_rsa.pem' do
  path '/home/ubuntu/.ssh/clm_rsa.pem'
  action :create_if_missing
  user 'ubuntu'
  mode '0400'
end

users = data_bag_item('users','users')

execute 'Assign build license' do
  command "ssh -o StrictHostKeyChecking=no -i '/home/ubuntu/.ssh/clm_rsa.pem' ubuntu@#{node['clm']['server_hostname']} \"cd /opt/IBM/JazzTeamServer/server/; sudo ./repotools-jts.sh -createUser adminUserId=#{users['admin']['userid']} adminPassword=#{node['clm']['admin_password']} userId=build jazzGroup='JazzUsers' licenseId='com.ibm.team.rtc.buildsystem'\""
  action :run
  returns [0,22]
end

poise_archive "Extract build toolkit zip" do
	path "https://depy.s3.amazonaws.com/clm/#{major_version}/#{node['clm']['build_zip']}"
	destination "#{Chef::Config['file_cache_path']}/BUILD"
  strip_components 0
	action :unpack
  not_if do ::Dir.exists?("#{Chef::Config['file_cache_path']}/BUILD") end
end

execute 'build toolkit installation' do
  command "/opt/IBM/InstallationManager/eclipse/tools/imcl install #{node['clm'][:build_package]} -repositories #{Chef::Config['file_cache_path']}/BUILD/im/repo/rtc-buildsystem-offering/offering-repo/repository.config -acceptLicense"
  action :run
end

poise_archive "Extract client zip" do
  path "https://depy.s3.amazonaws.com/clm/#{major_version}/#{node['clm']['client_zip']}"
  destination "#{Chef::Config['file_cache_path']}/CLIENT"
  strip_components 0
  action :unpack
  not_if do ::Dir.exists?("#{Chef::Config['file_cache_path']}/CLIENT") end
end

execute 'client installation' do
  command "/opt/IBM/InstallationManager/eclipse/tools/imcl install #{node['clm'][:client_package]} -repositories #{Chef::Config['file_cache_path']}/CLIENT/im/repo/rtc-client-full-p2-offering/offering-repo/repository.config -acceptLicense"
  action :run
end

include_recipe "depy-clm::__jbe_upstart" if node['platform_version'] == '14.04'
include_recipe "depy-clm::__jbe_systemd" if node['platform_version'] == '16.04'
