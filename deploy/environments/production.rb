name 'production'
description 'The master production branch'

default_attributes(
  'root_dir'=> '/var/webapps/example',
  'django_app' => {
    'settings_file' => 'production',
    'allow_hosts' => %w('example.com', '127.0.0.1')
  },
  'gunicorn' => {
    'port' => '8001',
    'num_worker' => '3'
  },
  'git'=> {
    'branch'=>'master'
  },
  'owner' => 'ubuntu',
  'group' => 'ubuntu',
)
