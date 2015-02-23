from fabric.contrib.files import exists
from fabric.operations import put, get
from fabric.colors import green, red
from fabric.api import env, local, sudo, run, cd, prefix, task, settings


# Server hosts
STAGING_USER = 'ubuntu'
PRODUCTION_USER = 'ubuntu'
STAGING_SERVER = '%s@54.68.3.255' % STAGING_USER
PRODUCTION_SERVER = '%s@54.68.3.255' % PRODUCTION_USER
APP_NAME = 'example'
DIR_WEBAPP = '/var/webapps'
REPO_NAME = 'https://github.com/vuchauthanh/chef-django-sample.git'


@task
def staging():
    """ Use staging server settings """
    global env
    print(green('Deploy for staging server.'))
    env.hosts = [STAGING_SERVER]
    env.key_filename = '/Volumes/Data/Keys/EC2/private/vuchau_ec2.pem'
    env['dir_app'] = '%s/%s' % (DIR_WEBAPP, APP_NAME)
    env['branch'] = 'develop'
    env['environment'] = 'staging',
    env['user'] = STAGING_USER


@task
def production():
    """ Use prod server settings """
    print(green('Deploy for production server.'))
    env.hosts = [PRODUCTION_SERVER]
    env.key_filename = '/Volumes/Data/Keys/EC2/private/vuchau_ec2.pem'
    env['dir_app'] = '%s/%s' % (DIR_WEBAPP, APP_NAME)
    env['branch'] = 'develop'
    env['environment'] = 'production'
    env['user'] = PRODUCTION_USER


def package_installed(pkg_name):
    """ref: http:superuser.com/questions/427318/#comment490784_427339"""
    cmd_f = 'dpkg-query -l "%s" | grep -q ^.i'
    cmd = cmd_f % (pkg_name)
    with settings(warn_only=True):
        result = run(cmd)
    return result.succeeded


@task
def install_chef(latest=True):
    """
    Install chef-solo on the server
    """
    sudo('apt-get update', pty=True)
    sudo('apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties', pty=True)

    if not package_installed('ruby'):
        run('cd ~/ && wget http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz')
        run('tar -xzvf ruby-2.1.5.tar.gz')
        run('cd ~/ruby-2.1.5/ && ./configure && make && sudo make install')

    if latest:
        sudo('gem install chef --no-ri --no-rdoc', pty=True)
    else:
        sudo('gem install chef --no-ri --no-rdoc', pty=True)

    sudo('gem install json')


@task
def bootstrap():
    """
    Bootstrap the specified server. Install chef then run chef solo.

    :param name: The name of the node to be bootstrapped
    :param no_install: Optionally skip the Chef installation
    since it takes time and is unneccesary after the first run
    :return:
    """

    print(green('Bootstrapping ...'))
    if not package_installed('chef'):
        install_chef()

    # Make root folder
    if not exists(env['dir_app']):
        sudo('mkdir -p %s' % DIR_WEBAPP)

    sudo('chown -R %s %s' % (env['user'], DIR_WEBAPP))

    with cd(DIR_WEBAPP):
        print(green('Cloning repo from GitHub...'))
        if not exists('%s' % APP_NAME):
            run('git clone %s %s' % (REPO_NAME, APP_NAME))


@task
def deploy():
    """
    Deploy to server
    """
    print(green('Deploying ...'))

    with cd(env['dir_app']):
        pass


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
