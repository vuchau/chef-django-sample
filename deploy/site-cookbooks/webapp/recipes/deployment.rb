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

execute 'restart supervisor' do
    command 'sudo /etc/init.d/supervisor restart'
end


######## NGINX ########
# Copy nginx config
template '/etc/nginx/sites-enabled/default' do
    source 'nginx.conf.erb'
    owner node['owner']
end

execute 'restart nginx' do
    command 'sudo /etc/init.d/nginx restart'
end
