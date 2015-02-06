# Webapp recipe
# ============

execute "clean it" do
    command "apt-get clean -y"
end

execute "update package index" do
    command "apt-get update"
end

# Base package
package "vim"
package "python-software-properties"
package "ntp"
package "curl"
package "htop"
package "mosh"

# Base recipe
include_recipe "openssl"
include_recipe "build-essential::default"
include_recipe "git"
include_recipe "python"
include_recipe "apt"
include_recipe "postgresql::server"

cookbook_file "/etc/postgresql/#{node[:postgresql][:version]}/main/pg_hba.conf" do
    source "pg_hba.conf"
    owner "postgres"
end

# Postgres database
execute "restart postgres" do
    command "sudo /etc/init.d/postgresql restart"
end

execute "create user" do
    command "createuser -Upostgres --superuser #{node[:user]}"
    not_if "psql -U postgres -c '\\du' | grep #{node[:user]}"
end

execute "create database" do
    command "createdb -U postgres -T template0 -O postgres #{node[:dbname]} -E UTF8 --locale=en_US.UTF-8"
    not_if "psql -U postgres --list | grep #{node[:dbname]}"
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
  #{node.default['webapp']['venv']}/bin/pip install -r #{node.default['webapp']['requirements_file']}
  EOH
end

