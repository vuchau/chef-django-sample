import os
from tempfile import mkdtemp
from contextlib import contextmanager

from fabric.operations import put
from fabric.colors import green, red
from fabric.api import env, local, sudo, run, cd, prefix, task, settings


env.roledefs = {
    'staging_prep': ['ubuntu@54.68.3.255']
}


CHEF_VERSION = '10.20.0'
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
    env.hosts = '54.68.3.255'
    env.key_filename = '/Volumes/Data/Keys/EC2/private/vuchau_ec2.pem'


def production():
    pass


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
