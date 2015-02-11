#
# Cookbook Name:: webapp
# Attributes:: webapp
#

case node[:owner]
when "vagrant"
    default['webapp']['source_dir'] = '/src'
else
    default['webapp']['source_dir'] = "#{node[:root_dir]}/src"
end

default['webapp']['root_dir'] = node[:root_dir]
default['webapp']['backend'] = "#{default['webapp']['source_dir']}/backend"
default['webapp']['logs'] = "#{default['webapp']['source_dir']}/logs"
default['webapp']['frontend'] = "#{default['webapp']['source_dir']}/frontend"
default['webapp']['venv'] = "#{default['webapp']['backend']}/venv"
default['webapp']['activate'] = "#{default['webapp']['venv']}/bin/activate"
default['webapp']['pip'] = "#{default['webapp']['venv']}/bin/pip"
default['webapp']['python'] = "#{default['webapp']['venv']}/bin/python"
default['webapp']['requirements_file'] = "#{default['webapp']['backend']}/requirements.txt"
default['webapp']['gunicorn_script'] = "#{default['webapp']['venv']}/gunicorn_script.sh"

# Get from bags
default['webapp']['settings_file'] = node[:django_app][:settings_file]
default['webapp']['gunicorn_port'] = node[:gunicorn].nil? ? "" : node[:gunicorn][:port]
default['webapp']['num_worker'] = node[:gunicorn].nil? ? "" : node[:gunicorn][:num_worker]

