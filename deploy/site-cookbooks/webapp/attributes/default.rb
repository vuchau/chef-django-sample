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
default['webapp']['frontend'] = "#{default['webapp']['source_dir']}/frontend"
default['webapp']['venv'] = "#{default['webapp']['backend']}/venv"
default['webapp']['requirements_file'] = "#{default['webapp']['backend']}/requirements.txt"
default['webapp']['gunicorn_script'] = "#{default['webapp']['venv']}/gunicorn_script.sh"
