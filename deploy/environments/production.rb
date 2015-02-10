name "production"
description "The master production branch"
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
    'settings_file' => 'production'
  },
  "gunicorn" => {
    "port" => 8001,
    "num_worker" =>"3"
  },

  'git'=> {
    'branch'=>'master'
  },
  "owner" => "ubuntu",
  "group" => "ubuntu",
)
