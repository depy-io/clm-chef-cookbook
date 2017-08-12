template "systemd jts" do
  path "/etc/systemd/system/jts.service"
  source "systemd_jts.erb"
  owner "root"
  group "root"
  mode  "0644"
  action :create
end

service "jts" do
  provider Chef::Provider::Service::Systemd
  action :start
  start_command "systemctl start jts"
  stop_command "systemctl stop jts"
  supports :restart => false, :reload => false, :status => true
  pattern '/opt/IBM/JazzTeamServer/server/jre/bin/java'
  only_if { File.exist?('/opt/IBM/JazzTeamServer/server/jre/bin/java') }
end
