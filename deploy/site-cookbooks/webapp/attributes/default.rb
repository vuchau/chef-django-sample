#
# Cookbook Name:: webapp
# Attributes:: webapp
#

settings = Chef::EncryptedDataBagItem.load('apps', 'example')

# Set default database info for development env
# Databse
username = node['owner']
db_password = node['owner']
db_name = "#{settings['app_name']}_dev"
root_db_password = 'postgres'
host = '127.0.0.1'
port = '5432'

# Django app
settings_file = 'local'
gunicorn_port = ''
gunicorn_num_worker = ''
django_user = 'admin'
django_password = 'admin'


# Check env
case node.chef_environment
when 'development'
  default['webapp']['source_dir'] = '/src'
else
  default['webapp']['source_dir'] = "#{node['root_dir']}/src"
  db_password = settings[node.chef_environment]['database']['password']
  db_name = settings[node.chef_environment]['database']['db_name']
  username = settings[node.chef_environment]['database']['db_user']
  root_db_password = settings[node.chef_environment]['database']['root_password']
  db_host = settings[node.chef_environment]['database']['host']
  db_host = settings[node.chef_environment]['database']['port']
  gunicorn_port = node['gunicorn']['port']
  gunicorn_num_worker = node['gunicorn']['num_worker']

end

default['webapp']['root_dir'] = node['root_dir']
default['webapp']['backend'] = "#{default['webapp']['source_dir']}/backend"
default['webapp']['logs'] = "#{default['webapp']['source_dir']}/logs"
default['webapp']['frontend'] = "#{default['webapp']['source_dir']}/frontend"
default['webapp']['venv'] = "#{default['webapp']['backend']}/venv"
default['webapp']['activate'] = "#{default['webapp']['venv']}/bin/activate"
default['webapp']['postactivate'] = "#{default['webapp']['venv']}/bin/postactivate"
default['webapp']['pip'] = "#{default['webapp']['venv']}/bin/pip"
default['webapp']['python'] = "#{default['webapp']['venv']}/bin/python"
default['webapp']['requirements_file'] = "#{default['webapp']['backend']}/requirements.txt"
default['webapp']['gunicorn_script'] = "#{default['webapp']['venv']}/gunicorn_script.sh"

# Get from bags and set values for each envs
# Database
default['webapp']['db_password'] = db_password
default['webapp']['db_name'] = db_name
default['webapp']['db_user'] = username
default['webapp']['root_db_password'] = root_db_password
default['webapp']['db_host'] = host
default['webapp']['db_port'] = port

# django app
default['webapp']['settings_file'] = node['django_app']['settings_file']
default['webapp']['gunicorn_port'] = gunicorn_port
default['webapp']['num_worker'] = gunicorn_num_worker
default['webapp']['user'] = django_user
default['webapp']['password'] = django_password


