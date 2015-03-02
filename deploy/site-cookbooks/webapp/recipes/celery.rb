include_recipe 'redisio'
include_recipe 'redisio::enable'

# Generate local settings for web-admin app
template "#{node.default['webapp']['celery_script']}" do
    source  'celery_run.sh.erb'
    owner node['owner']
    group node['group']
    mode '0755'
end

# Generate a supervisor service entry and autostart it
supervisor_service "celery" do
    command "#{node.default['webapp']['celery_script']}"
    directory "#{node.default['webapp']['backend']}"
    autostart true
    autorestart true
    stdout_logfile "#{node.default['webapp']['logs']}/celery-worker.log"
    stderr_logfile "#{node.default['webapp']['logs']}/celery-worker-error.log"

    user  node['owner']

    # Need to wait for currently executing tasks to finish at shutdown.
    # Increase this if you have very long running tasks.
    stopwaitsecs    600

    # When resorting to send SIGKILL to the program to terminate it
    # send SIGKILL to its whole process group instead,
    # taking care of its children as well.
    killasgroup     true
end
