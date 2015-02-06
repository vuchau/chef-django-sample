#
# Cookbook Name:: webapp
# Attributes:: webapp
#

case node[:user]
when "vagrant"
    default['webapp']['root_dir'] = '/src'
    default['webapp']['venv'] = '/src/backend/venv'
else
    default['webapp']['root_dir'] = '/var/webapps/example'
    default['webapp']['venv'] = '/var/webapps/example/venv'
end
