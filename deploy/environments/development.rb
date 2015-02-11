name 'development'
description 'The master development branch'

cookbook_versions({

})

default_attributes(
  'build-essential' => {
    'compile_time' => true
  },
  'postgresql' => {
    'password' => {
        'postgres' => 'Abcde@12345',
        'vagrant' => 'vagrant'
    }
  },
  'root_dir' => '/src',
  'django_app' => {
    'settings_file' => 'local'
  },
  'owner' => 'vagrant',
  'group' => 'vagrant'
)
