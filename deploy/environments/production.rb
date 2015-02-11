name "production"
description "The master production branch"
cookbook_versions({

})

settings = Chef::EncryptedDataBagItem.load('apps', 'example')

default_attributes(
  'build-essential' => {
    'compile_time' => true
  },
  'postgresql'=> {
    'password' => {
        'postgres'=> settings['databases']['password']
    }
  },
  'root_dir'=> '/var/webapps/example',
  'django_app' => {
    'settings_file' => 'production'
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
