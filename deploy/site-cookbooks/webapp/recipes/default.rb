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
include_recipe "postgresql::client"

# Get data from bags
settings = Chef::EncryptedDataBagItem.load('apps', 'example')

# Check environment to pull code from git repo
if node.chef_environment == 'development'
  template '/home/vagrant/.bash_profile' do
    source 'bash_profile.erb'
    owner node['owner']
  end
else
  directory node['root_dir'] do
    path node['root_dir']
    owner node['owner']
    group node['group']
    mode '0755'
    action :create
  end

  # Pull code
  git "#{node['root_dir']}" do
    repository settings['repository']
    revision node['git']['branch']
    action 'sync'
  end
end

# Python environment
python_virtualenv node.default['webapp']['venv'] do
  action :create
  owner node['owner']
  group node['group']
end

# execute 'Install requirements for python application' do
#   command "#{node.default['webapp']['pip']} install -r #{node.default['webapp']['requirements_file']}"
# end

# Copy postactivate
template "#{node.default['webapp']['postactivate']}" do
    source 'virtualenv_postactivate.erb'
    owner node['owner']
end

Chef::Log.info("#{node.default['webapp']['postactivate']}")

ruby_block "Insert source postactivate" do
  block do
    file = Chef::Util::FileEdit.new("#{node.default['webapp']['activate']}")
    file.insert_line_if_no_match("/source #{node.default['webapp']['postactivate']}/", "source #{node.default['webapp']['postactivate']}")
    file.write_file
  end
end

execute 'Syncdb' do
  command "#{node.default['webapp']['python']} #{node.default['webapp']['backend']}/manage.py syncdb --noinput --settings=backend.settings.#{node.default['webapp']['settings_file']}"
end

execute 'Migrate' do
  command "#{node.default['webapp']['python']} #{node.default['webapp']['backend']}/manage.py migrate  --settings=backend.settings.#{node.default['webapp']['settings_file']}"
end
