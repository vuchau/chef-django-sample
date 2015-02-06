include_recipe "nginx"
include_recipe "supervisor"
include_recipe "redis"


service "supervisor" do
    action :stop
end

service "supervisor" do
    action :start
end
