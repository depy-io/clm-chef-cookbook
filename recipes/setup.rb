if node['ec2'].nil?
  clm_server_hostname = node['hostname']
else
  clm_server_hostname = node['ec2']['public_hostname']
end

template "Setup Properties File RDM False" do
	path "#{Chef::Config['file_cache_path']}/CLM.properties"
	source 'CLM.properties.erb'
	variables (
  		lazy {
  			{
  				:use_rdm => 'false',
				  :server_hostname => "#{clm_server_hostname}"
			}
		}
	)
	action :create
	notifies :run, 'execute[CLM Setup without RDM]', :immediately
end

execute 'CLM Setup without RDM' do
	cwd "/opt/IBM/JazzTeamServer/server"
	command "bash -c 'ulimit -n 65536;ulimit -u 10000;./repotools-jts.sh -setup includeLifecycleProjectStep=true parametersfile=#{Chef::Config['file_cache_path']}/CLM.properties'"
	action :nothing
end

include_recipe "clm::patch" if node['clm']['fix'].to_s != ""
include_recipe "clm::__gcm" if node['gcm']['active'] and node['clm']['version'].to_s >=  '6.0.0'
