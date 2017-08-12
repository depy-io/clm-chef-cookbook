template "Setup jts.conf" do
  path "/etc/init/jts.conf"
  source 'jts.conf.erb'
  action :create
end

service 'jts' do
  provider Chef::Provider::Service::Upstart
  supports :start => true, :stop => true
  action [ :enable, :start ]
end

execute 'Wait for jts service to start up before proceeding' do
  command 'sleep 60'
end

#execute 'Wait for jts service to start up before proceeding' do
#  command 'curl -D - --silent --max-time 5 https://localhost:9443/jts/admin'
#  retries 60
#  retry_delay 5
#end