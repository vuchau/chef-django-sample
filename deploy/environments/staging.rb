name "staging"
description "The master staging branch"
cookbook_versions({

})

default_attributes(
  'build-essential' => {
    'compile_time' => true
  },
  'postgresql'=> {
    'password' => {
        'postgres'=> 'Abcde@12345',
        'vagrant'=> 'vagrant'
    }
  },
  'root_dir'=> '/var/webapps/example',
  'django_app' => {
    'settings_file' => 'staging'
  },
  "gunicorn" => {
    "port" => 8001,
    "num_worker" =>"3"
  },

  'git'=> {
    'branch'=>'develop'
  },
  "owner" => "ubuntu",
  "group" => "ubuntu",
)
