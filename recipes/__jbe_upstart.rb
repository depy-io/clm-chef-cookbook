template "jbe deamon" do
  path "/etc/default/jbe-deamon.sh"
  source "jbe-deamon.sh.erb"
  owner "root"
  group "root"
  mode  "0755"
  action :create
end

template "Setup jbe.conf" do
  path "/etc/init/jbe.conf"
  source 'jbe.conf.erb'
  action :create
end

service 'jbe' do
  provider Chef::Provider::Service::Upstart
  supports :start => true, :stop => true
  action [ :enable, :start ]
end