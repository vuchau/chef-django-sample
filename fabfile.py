import os
from tempfile import mkdtemp
from contextlib import contextmanager

from fabric.operations import put
from fabric.colors import green, red
from fabric.api import env, local, sudo, run, cd, prefix, task, settings


# Server hosts
STAGING_USER = 'ubuntu'
PRODUCTION_USER = 'ubuntu'
STAGING_SERVER = '%s@54.68.3.255' % STAGING_USER
PRODUCTION_SERVER = '%s@54.68.3.255' % PRODUCTION_USER
GIT_REPO = 'https://github.com/vuchauthanh/django-chef.git'

# Application settings
env.app_name = 'example'
env.root_dir = '/var/webapps/%s' % env.app_name
env.backend_dir = '%s/src/backend' % env.root_dir
env.frontenf_dir = '%s/src/frontend' % env.root_dir
env.virtualenv = '%s/venv' % env.backend_dir
env.activate = 'source %s/bin/activate ' % env.virtualenv
env.media_dir = '%s/media' % env.backend_dir


@contextmanager
def _virtualenv():
    with prefix(env.activate):
        yield


def _manage_py(command):
    run('python manage.py %s --settings=example.settings_server' % command)


def staging():
    """ Use staging server settings """
    global env
    print(green('Deploy for staging server.'))
    env.hosts = [STAGING_SERVER]
    env.key_filename = '/Volumes/Data/Keys/EC2/private/vuchau_ec2.pem'
    env['server'] = 'staging'
    env['settings'] = '--settings=backend.settings.staging'
    env['dir_web'] = '/home/%s/webapps' % STAGING_USER
    env['nginx_conf'] = '/etc/nginx/sites-enabled/default'
    env['username'] = STAGING_USER
    env['git_branch'] = 'develop'
    env['git_updated'] = False
    env['environment'] = 'staging'
    set_env()


def production():
    """ Use prod server settings """
    global env
    print(green('Deploy for production server.'))
    env.hosts = [PRODUCTION_SERVER]
    env.key_filename = '/Volumes/Data/Keys/EC2/private/vuchau_ec2.pem'
    env['server'] = "production"
    env['settings'] = "--settings=backend.settings.production"
    env['dir_web'] = '/home/%s/webapps' % PRODUCTION_USER
    env['nginx_conf'] = '/etc/nginx/sites-enabled/default'
    env['username'] = PRODUCTION_USER
    env['git_branch'] = 'production'
    env['git_updated'] = False
    env['environment'] = 'production'
    set_env()


def set_env():
    global env
    # Directories
    env['dir_app'] = '%s/%s' % (env['dir_web'], APP_NAME)
    env['dir_backend'] = '%s/src/backend' % env['dir_app']
    env['dir_backend_settings'] = '%s/backend/settings' % env['dir_backend']
    env['dir_frontend'] = '%s/src/frontend' % env['dir_app']
    env['dir_scripts'] = '%s/scripts' % env['dir_app']
    env['dir_conf'] = '%s/scripts/conf' % env['dir_app']
    env['dir_logs'] = '%s/logs' % env['dir_web']
    env['dir_csv'] = '%s/csv_files' % env['dir_web']
    env['log_file_name'] = 'backend.log'
    env['backend_error_log'] = 'backend_error.log'
    env['dir_venv'] = '%s/%s' % (env['dir_backend'], VENV_NAME)

@task
def install_chef(latest=True):
    """
    Install chef-solo on the server
    """
    sudo('apt-get update', pty=True)
    sudo('apt-get install -y git-core rubygems ruby ruby-dev', pty=True)

    if latest:
        sudo('gem install chef --no-ri --no-rdoc', pty=True)
    else:
        sudo('gem install chef --no-ri --no-rdoc', pty=True)

    sudo('gem uninstall --no-all --no-executables --no-ignore-dependencies json')
    sudo('gem install json')


def start():
    print(green('Restarting supervisor service ...'))
    sudo('supervisorctl reload')
    print(green('Restarting nginx service ...'))
    sudo('service nginx restart')


def stop():
    print(green('Stop supervisor service ...'))
    sudo('supervisorctl stop backend')

    print(green('Stop nginx service ...'))
    sudo('service nginx stop')


def restart():
    print(green('Restarting supervisor service ...'))
    run('sudo supervisorctl reload')
    print(green('Restarting nginx service ...'))
    sudo('service nginx restart')


def tail_log(log='access'):
    """ Tail log file. """
    with cd(env['dir_logs']):
        sudo('tail -f %s' % env['log_file_name'])


def get_log(log='access'):
    """ Tail log file. """
    with cd(env['dir_logs']):
        get('%s' % env['log_file_name'])


def shell_plus():
    """ Run shell_plus """
    with prefix('source %s/bin/activate' % env['dir_venv']):
        run('python %s/manage.py shell_plus  %s' % (env['dir_backend'],
            env['settings']))
