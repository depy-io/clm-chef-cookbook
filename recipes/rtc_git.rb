service 'jts' do
  action :stop
end

cookbook_file "/opt/IBM/JazzTeamServer/server/liberty/servers/clm/apps/jts.war/WEB-INF/web.xml" do
  source 'jts.web.xml'
  action :create
end

cookbook_file "/opt/IBM/JazzTeamServer/server/liberty/servers/clm/apps/ccm.war/WEB-INF/web.xml" do
  source 'ccm.web.xml'
  action :create
end

service 'jts' do
  action :start
end