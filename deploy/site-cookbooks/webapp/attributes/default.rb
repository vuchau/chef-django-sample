#
# Cookbook Name:: webapp
# Attributes:: webapp
#

case node[:user]
when "vagrant"
    default['webapp']['root_dir'] = '/src'
    default['webapp']['source_dir'] = '/src'
else
    default['webapp']['root_dir'] = '/var/webapps/example'
    default['webapp']['source_dir'] = "#{default['webapp']['root_dir']}/src"
end

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
default['webapp']['settings_file'] = ""
default['webapp']['gunicorn_port'] = ""
default['webapp']['num_worker'] = ""

default['webapp']['owner'] = ""
default['webapp']['group'] = ""

