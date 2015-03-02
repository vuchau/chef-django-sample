#
# Cookbook Name:: webapp
# Attributes:: webapp
#

# database = Chef::EncryptedDataBagItem.load('secrets', 'database')
# settings = Chef::EncryptedDataBagItem.load('secrets', 'webapp')

if node['data_bag']['encrypted']
  app = Chef::EncryptedDataBagItem.load('globals', 'webapp_info')
  database = Chef::EncryptedDataBagItem.load('secrets_info', 'database')
else
  app =  Chef::DataBagItem.load('globals', 'webapp_info')
  database = Chef::DataBagItem.load('globals', 'database_password')
end

# Retry global information from databag
app_name = app['app_name']

# Set default database info for development env
# Databse
username = node['owner']
db_password = node['owner']
db_name = "#{app_name}_dev"
root_db_password = 'postgres'
db_host = '127.0.0.1'
db_port = '5432'

# Django app
settings_file = 'local'
gunicorn_port = '8001'
gunicorn_num_worker = '1'
django_user = 'admin'
django_password = 'admin'


# Check env
case node.chef_environment
when 'development'
  default['webapp']['source_dir'] = '/src'
else
  default['webapp']['source_dir'] = "#{node['root_dir']}/#{app_name}/src"
  db_password = database[node.chef_environment]['db_pass']
  db_name = database[node.chef_environment]['db_name']
  db_user = database[node.chef_environment]['db_user']
  root_db_password = database[node.chef_environment]['root_password']
  db_host = database[node.chef_environment]['db_host']
  db_port = database[node.chef_environment]['db_port']
  gunicorn_port = node['gunicorn']['port']
  gunicorn_num_worker = node['gunicorn']['num_worker']
end

default['webapp']['root_dir'] = node['root_dir']
default['webapp']['backend'] = "#{default['webapp']['source_dir']}/backend"
default['webapp']['logs'] = "#{node['root_dir']}/logs"
default['webapp']['frontend'] = "#{default['webapp']['source_dir']}/frontend"
default['webapp']['venv'] = "#{default['webapp']['backend']}/venv"
default['webapp']['activate'] = "#{default['webapp']['venv']}/bin/activate"
default['webapp']['celery'] = "#{default['webapp']['venv']}/bin/celery"
default['webapp']['postactivate'] = "#{default['webapp']['venv']}/bin/postactivate"
default['webapp']['pip'] = "#{default['webapp']['venv']}/bin/pip"
default['webapp']['python'] = "#{default['webapp']['venv']}/bin/python"
default['webapp']['requirements_file'] = "#{default['webapp']['backend']}/requirements/#{node.chef_environment}.txt"
default['webapp']['gunicorn_script'] = "#{default['webapp']['venv']}/gunicorn_script.sh"
default['webapp']['celery_script'] = "#{default['webapp']['venv']}/celery_script.sh"

# Get from bags and set values for each envs
# Database
default['webapp']['db_password'] = db_password
default['webapp']['db_name'] = db_name
default['webapp']['db_user'] = username
default['webapp']['root_db_password'] = root_db_password
default['webapp']['db_host'] = db_host
default['webapp']['db_port'] = db_port

# django app
default['webapp']['settings_file'] = node['django_app']['settings_file']
default['webapp']['gunicorn_port'] = gunicorn_port
default['webapp']['num_worker'] = gunicorn_num_worker
default['webapp']['user'] = django_user
default['webapp']['password'] = django_password


