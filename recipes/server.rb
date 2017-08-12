include_recipe "depy-iim"

cookbook_file "clm_rsa.pub" do
  user 'ubuntu'
  path "/home/ubuntu/.ssh/clm_rsa.pub"
  action :create_if_missing
  notifies :run, 'execute[copy ssh public key]',  :immediately
end

execute "copy ssh public key" do
  user 'ubuntu'
  command "cat /home/ubuntu/.ssh/clm_rsa.pub >> /home/ubuntu/.ssh/authorized_keys"
  action :nothing
end

apt_update "all platforms" do
  action :update
end

package "Install packages for RDNG graphic artifacts" do
  package_name ['xvfb','xfonts-100dpi','xfonts-75dpi','xfonts-scalable','xfonts-cyrillic','libgtk2.0-0', 'libstdc++5', 'libswt-gtk-3-jni', 'libswt-gtk-3-java']
  action :install
end

major_version = node['clm']['version'].split('_')[0]

poise_archive "Extract CLM zip" do
  path "https://depy.s3.amazonaws.com/clm/#{major_version}/#{node['clm']['zip']}"
  destination "#{Chef::Config['file_cache_path']}/CLM"
  strip_components 0
  action :unpack
  notifies :run, 'execute[CLM Installation]', :immediately
end

execute 'CLM Installation' do
  command "bash -c 'ulimit -n 65536;ulimit -u 10000;/opt/IBM/InstallationManager/eclipse/tools/imcl install #{node['clm']['packages']} -repositories #{Chef::Config['file_cache_path']}/CLM/repository.config -acceptLicense'"
  action :nothing
end

include_recipe "depy-clm::__upstart" if node['platform_version'] == '14.04'
include_recipe "depy-clm::__systemd" if node['platform_version'] == '16.04'

include_recipe "depy-clm::__screen_capture" if node['clm']['rtc_screen_capture_jar'].to_s != "" and node['clm']['rqm_screen_capture_jar'].to_s != ""
