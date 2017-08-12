template "systemd jbe" do
  path "/etc/systemd/system/jbe.service"
  source "systemd_jbe.erb"
  owner "root"
  group "root"
  mode  "0644"
  action :create
end

template "jbe deamon" do
  path "/etc/default/jbe-deamon.sh"
  source "jbe-deamon.sh.erb"
  owner "root"
  group "root"
  mode  "0755"
  action :create
end

service "jbe" do
  provider Chef::Provider::Service::Systemd
  action :start
  start_command "systemctl start jbe"
  stop_command "systemctl stop jbe"
  supports :restart => false, :reload => false, :status => true
  pattern '/opt/IBM/TeamConcertBuild/buildsystem/buildengine/eclipse/jbe.sh'
  only_if { File.exist?('/opt/IBM/TeamConcertBuild/buildsystem/buildengine/eclipse/jbe.sh') }
end