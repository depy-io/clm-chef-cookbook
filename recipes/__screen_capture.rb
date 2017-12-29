major_version = node['clm']['version'].split('_')[0]

users = data_bag_item('users','users')

poise_archive "Extract RTC screen capture jar" do
  path "https://depy.s3.amazonaws.com/clm/#{major_version}/#{node['clm']['rtc_screen_capture_jar_zip']}"
  destination "#{Chef::Config['file_cache_path']}/RTC_screen_capture"
  strip_components 0
  action :unpack
end

poise_archive "Extract RQM screen capture jar" do
  path "https://depy.s3.amazonaws.com/clm/#{major_version}/#{node['clm']['rqm_screen_capture_jar_zip']}"
  destination "#{Chef::Config['file_cache_path']}/RQM_screen_capture"
  strip_components 0
  action :unpack
end

execute "authenticate" do
  command "curl -v -k -c /var/tmp/jazzCookies.txt -u #{users['admin']['userid']}:#{users['admin']['password']} https://#{node['ec2']['public_hostname']}:9443/ccm/secure/authenticated/identity"
  action :run
end

execute "security check" do
  command "curl -v -k -b /var/tmp/jazzCookies.txt -c /var/tmp/jazzCookies.txt -d j_username=#{users['admin']['userid']} -d j_password=#{users['admin']['password']} https://#{node['ec2']['public_hostname']}:9443/ccm/authenticated/j_security_check"
  action :run
end

execute "RTC requestRest" do
  command "curl -v -k -b /var/tmp/jazzCookies.txt -c /var/tmp/jazzCookies -u #{users['admin']['userid']}:#{users['admin']['password']} https://#{node['ec2']['public_hostname']}:9443/ccm/admin/cmd/requestReset"
  action :run
end

execute "RQM requestRest" do
  command "curl -v -k -b /var/tmp/jazzCookies.txt -c /var/tmp/jazzCookies -u #{users['admin']['userid']}:#{users['admin']['password']} https://#{node['ec2']['public_hostname']}:9443/qm/admin/cmd/requestReset"
  action :run
end

service 'jts' do
  action :stop
end

execute 'Wait for jts service to stop before proceeding' do
  command 'sleep 20'
end

file "/opt/IBM/JazzTeamServer/server/conf/ccm/sites/rtc-commons-update-site/plugins/#{node['clm']['rtc_screen_capture_jar']}" do
  action :delete
end

remote_file "/opt/IBM/JazzTeamServer/server/conf/ccm/sites/rtc-commons-update-site/plugins/#{node['clm']['rtc_screen_capture_jar']}" do
  source "file://#{Chef::Config['file_cache_path']}/RTC_screen_capture/#{node['clm']['rtc_screen_capture_jar']}"
  action :create
end


file "/opt/IBM/JazzTeamServer/server/conf/qm/sites/rqm-update-site/plugins/#{node['clm']['rqm_screen_capture_jar']}" do
  action :delete
end

remote_file "/opt/IBM/JazzTeamServer/server/conf/qm/sites/rqm-update-site/plugins/#{node['clm']['rqm_screen_capture_jar']}" do
  source "file://#{Chef::Config['file_cache_path']}/RQM_screen_capture/#{node['clm']['rqm_screen_capture_jar']}"
  action :create
end

service 'jts' do
  action :start
end

execute 'Wait for jts service to start up before proceeding' do
  command 'sleep 60'
end
