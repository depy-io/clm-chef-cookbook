service 'jts' do
  action :stop
end

uuid = SecureRandom.uuid

[ "jts", "rm", "qm" ].each do |app|
  
  java_properties "/opt/IBM/JazzTeamServer/server/conf/#{app}/teamserver.properties" do
    properties_file "/opt/IBM/JazzTeamServer/server/conf/#{app}/teamserver.properties"
    property 'com.ibm.team.repository.vvc.activationKey', "#{uuid}"
  end
  
end

service 'jts' do
  action :start
end

execute 'Wait for jts service to start up before proceeding' do
  command 'sleep 60'
end