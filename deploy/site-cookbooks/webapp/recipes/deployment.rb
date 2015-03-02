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
# Generate a supervisor service entry and autostart it
supervisor_service "webapp" do
    command "#{node.default['webapp']['gunicorn_script']}"
    directory "#{node.default['webapp']['backend']}"
    autostart true
    autorestart true
    stdout_logfile "#{node.default['webapp']['logs']}/supervisord.log"
    stderr_logfile "#{node.default['webapp']['logs']}/supervisord-error.log"

    user  node['owner']

    # Need to wait for currently executing tasks to finish at shutdown.
    # Increase this if you have very long running tasks.
    stopwaitsecs    600

    # When resorting to send SIGKILL to the program to terminate it
    # send SIGKILL to its whole process group instead,
    # taking care of its children as well.
    killasgroup     true
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
