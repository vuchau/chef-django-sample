# Webapp recipe
# ============

# Base package
package "python-software-properties"
package "ntp"
package "curl"
package "htop"
package "mosh"

# Base recipe

include_recipe "build-essential"
include_recipe "git"
include_recipe "python"
include_recipe "apt"
include_recipe "postgresql::server"

# Get data from bags
settings = data_bag_item("apps", "example")

# Check environment to pull code from git repo
if node.chef_environment != 'development'
    execute "Create application dir" do
        command "mkdir -p #{node[:root_dir]}"
    end

    # Pull code
    git "#{node[:root_dir]}" do
      repository settings['repository']
      revision node[:git][:branch]
      action "sync"
    end
end

# Postgres database
cookbook_file "/etc/postgresql/#{node[:postgresql][:version]}/main/pg_hba.conf" do
    source "pg_hba.conf"
    owner "postgres"
end

execute "create database" do
    command "createdb -U postgres -T template0 -O postgres #{settings['databases']['name']} -E #{settings['databases']['encoding']} --locale=#{settings['databases']['locale']}"
    not_if "psql -U postgres --list | grep #{settings['databases']['name']}"
end

execute "create user" do
    command "createuser -Upostgres --superuser #{settings['databases']['username']}"
    not_if "psql -U postgres -c '\\du' | grep #{settings['databases']['username']}"
end


# Python environment
python_virtualenv node.default['webapp']['venv'] do
    action :create
    owner node[:owner]
    group node[:group]
end

execute "Install requirements for python application" do
    command "#{node.default[:webapp][:pip]} install -r #{node.default[:webapp][:requirements_file]}"
end

execute "Syncdb" do
    command "#{node.default['webapp']['python']} #{node.default[:webapp][:backend]}/manage.py syncdb --noinput --settings=backend.settings.#{node.default[:webapp][:settings_file]}"
end

execute "Syncdb" do
    command "#{node.default['webapp']['python']} #{node.default[:webapp][:backend]}/manage.py migrate  --settings=backend.settings.#{node.default[:webapp][:settings_file]}"
end




