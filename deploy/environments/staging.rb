name "staging"
description "The master staging branch"

default_attributes(
  'root_dir'=> '/var/webapps/example',
  'django_app' => {
      'settings_file' => 'staging',
      'allow_hosts' => %w('52.10.221.175','127.0.0.1')
  },
  'gunicorn' => {
      'port' => '8001',
      'num_worker' => '3'
  },

  'git'=> {
      'branch'=>'master'
  },
  'owner' => 'vagrant',
  'group' => 'vagrant',
)


