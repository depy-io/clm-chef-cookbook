include_recipe "depy-iim"

service 'JTS' do
	action :stop
	only_if { node['clm']['use_rdm'] }
end

execute 'rdm Installation' do
	user 'root'
	command "/opt/IBM/InstallationManager/eclipse/tools/imcl install #{node['clm'][:rdm_packages]} -repositories #{Chef::Config['file_cache_path']}/CLM/repository.config -acceptLicense"
	action :run
	only_if { node['clm']['use_rdm'] }
end

=begin

directory "/opt/IBM/JazzTeamServer/server/patch" do
	not_if { node['clm']['rdm_fix'].to_s == '' }
	action :create
end

directory "/opt/IBM/JazzTeamServer/server/conf/dm/patch" do
	not_if { node['clm']['rdm_fix'].to_s == '' }
	recursive true
	action :delete
end

remote_file "Download RDM Fix" do
	not_if { node['clm']['rdm_fix'].to_s == '' }
    path "#{Chef::Config['file_cache_path']}/#{node['clm']['rdm_fix']}"
	source "https://lmbgalaxy.s3.amazonaws.com/IBM/CLM/#{node['clm']['rdm_fix']}"
	action :create
end

libarchive_file "Extract RDM fix zip" do
	not_if { node['clm']['rdm_fix'].to_s == '' }
	path "#{Chef::Config['file_cache_path']}/#{node['clm']['rdm_fix']}"
	extract_to "#{Chef::Config['file_cache_path']}/RDM_FIX"
	action :extract
end

remote_file "Copy RDM server patch" do 
	not_if { node['clm']['rdm_fix'].to_s == '' }
	path "/opt/IBM/JazzTeamServer/server/patch/#{node['clm']['rdm_server_patch']}" 
	source "file://#{Chef::Config['file_cache_path']}/RDM_FIX/#{node['clm']['rdm_server_patch']}"
end

directory "/opt/IBM/JazzTeamServer/RhapsodyModelServer" do
	not_if { node['clm']['RhapsodyModelServer_fix'].to_s == '' }
	recursive true
	action :delete
end

remote_file "Download RhapsodyModelServer Fix" do
	not_if { node['clm']['RhapsodyModelServer_fix'].to_s == '' }
    path "#{Chef::Config['file_cache_path']}/#{node['clm']['RhapsodyModelServer_fix']}"
	source "https://lmbgalaxy.s3.amazonaws.com/IBM/CLM/#{node['clm']['RhapsodyModelServer_fix']}"
	action :create
end

libarchive_file "Extract RhapsodyModelServer fix zip" do
	not_if { node['clm']['RhapsodyModelServer_fix'].to_s == '' }
	path "#{Chef::Config['file_cache_path']}/#{node['clm']['RhapsodyModelServer_fix']}"
	extract_to "#{Chef::Config['file_cache_path']}/RHAP_DM_FIX"
	action :extract
end

libarchive_file  "Extract RhapsodyModelServer linux fix" do 
	not_if { node['clm']['RhapsodyModelServer_fix'].to_s == '' }
	path "#{Chef::Config['file_cache_path']}/RHAP_DM_FIX/#{node['clm']['RhapsodyModelServer_linux_fix']}"
	extract_to "/opt/IBM/JazzTeamServer/RhapsodyModelServer"
	action :extract
end

remote_file "Copy dm.war.zip" do 
	path "/opt/IBM/JazzTeamServer/server/liberty/servers/clm/apps/dm.war.zip" 
	source "file:///opt/IBM/JazzTeamServer/server/liberty/clmServerTemplate/apps/dm.war.zip"
end

libarchive_file "Extract dm.war.zip" do
	path "/opt/IBM/JazzTeamServer/server/liberty/servers/clm/apps/dm.war.zip"
	extract_to "/opt/IBM/JazzTeamServer/server/liberty/servers/clm/apps/dm.war"
	action :extract
end

=end

service 'JTS' do
	action :start
	only_if { node['clm']['use_rdm'] }
end