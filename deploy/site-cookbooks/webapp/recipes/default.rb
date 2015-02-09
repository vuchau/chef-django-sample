# Webapp recipe
# ============



# Base package
package "vim"
package "python-software-properties"
package "ntp"
package "curl"
package "htop"
package "mosh"

# Base recipe
include_recipe "openssl"
include_recipe "build-essential"
include_recipe "git"
include_recipe "python"
include_recipe "apt"
include_recipe "postgresql::server"
include_recipe "vim"

# Get data from bags
app = data_bag_item("apps", "example")
app1 = data_bag_item("apps", "example1")

# Overwrite attribute
node.default['webapp']['settings_file'] = app['django_app']['settings_file']
node.default['webapp']['gunicorn_port'] = app['gunicorn']['port']
node.default['webapp']['num_worker'] = app['gunicorn']['num_worker']

cookbook_file "/etc/postgresql/#{node[:postgresql][:version]}/main/pg_hba.conf" do
    source "pg_hba.conf"
    owner "postgres"
end

# Postgres database
execute "restart postgres" do
    command "sudo /etc/init.d/postgresql restart"
end

execute "create user" do
    command "createuser -Upostgres --superuser #{app['databases']['username']}"
    not_if "psql -U postgres -c '\\du' | grep #{app['databases']['username']}"
end

execute "create database" do
    command "createdb -U postgres -T template0 -O postgres #{app['databases']['name']} -E #{app['databases']['encoding']} --locale=#{app['databases']['locale']}"
    not_if "psql -U postgres --list | grep #{app['databases']['name']}"
end

# Python environment
python_virtualenv node.default['webapp']['venv'] do
    action :create
    owner node[:user]
    group node[:user]
end

script "Install requirements for python application" do
  interpreter "bash"
  user node[:user]
  group node[:user]
  code <<-EOH
  #{node.default[:webapp][:pip]} install -r #{node.default[:webapp][:requirements_file]}
  EOH
end

script "Syncdb" do
  interpreter "bash"
  user node[:user]
  group node[:user]
  code <<-EOH
  #{node.default['webapp']['python']} #{node.default[:webapp][:backend]}/manage.py syncdb --noinput --settings=backend.settings.#{node.default[:webapp][:settings_file]}
  EOH
end

script "Migrate" do
  interpreter "bash"
  user node[:user]
  group node[:user]
  code <<-EOH
  #{node.default['webapp']['python']} #{node.default[:webapp][:backend]}/manage.py migrate --settings=backend.settings.#{node.default[:webapp][:settings_file]}
  EOH
end



