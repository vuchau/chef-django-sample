include_recipe 'openssl'
include_recipe 'nginx'
include_recipe 'supervisor'

######## GUNICORN ########
template node.default['webapp']['gunicorn_script'] do
    source 'gunicorn_script.sh.erb'
    owner node['owner']
    mode '0755'
end

######## SUPERVISIOR ########
# Copy supvisior script
template '/etc/supervisor.d/backend.conf' do
    source 'supervisior.conf.erb'
    owner node['owner']
end

service 'supervisor' do
  action:restart
end


######## NGINX ########
# Copy nginx config
template '/etc/nginx/sites-enabled/default' do
    source 'nginx.conf.erb'
    owner node['owner']
end

service 'nginx' do
  action:restart
end
