include_recipe "postgresql::server"
# Get data from bags
::Chef::Recipe.send(:include, WebappHelpers)

# Retry global information from databag
app_name = get_app_name

# Set default database info for development env
# Databse
username = node['owner']
db_password = node['owner']
db_name = "#{app_name}_dev"
root_db_password = 'postgres'
db_host = '127.0.0.1'
db_port = '5432'

# Postgres database
template ("/etc/postgresql/#{node['postgresql']['version']}/main/pg_hba.conf") do
  source 'pg_hba.conf.erb'
  owner 'postgres'
end

service 'postgresql' do
  action :restart
end

execute 'Create database' do
    command "createdb -U postgres -T template0 -O postgres #{node.default['webapp']['db_name']} -E UTF8 --locale=en_US.UTF-8"
    not_if "psql -U postgres --list | grep #{node.default['webapp']['db_name']}"
end

execute 'Create user' do
    command "createuser -Upostgres --superuser #{node.default['webapp']['db_user']}"
    not_if "psql -U postgres -c '\\du' | grep #{node.default['webapp']['db_user']}"
end

execute 'Change password postgres' do
    command "psql -U postgres -c \"alter user postgres with password '#{node.default['webapp']['root_db_password']}'\""
end

execute 'Change password userdb' do
    command "psql -U postgres -c \"alter user #{node.default['webapp']['db_user']} with password '#{node.default['webapp']['db_password']}'\""
end
