include_recipe 'openssl'
include_recipe 'nginx'
include_recipe 'supervisor'

# Get data from bags
settings = data_bag_item('apps', 'example')

# Overwrite attribute
node.default['webapp']['settings_file'] = settings['django_app']['settings_file']
node.default['webapp']['gunicorn_port'] = settings['gunicorn']['port']
node.default['webapp']['num_worker'] = settings['gunicorn']['num_worker']

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
