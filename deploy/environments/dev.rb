name 'dev'
description 'The master development branch'

default_attributes(
  'data_bag' => {
      'encrypted' => false
  },
  'root_dir' => '/src',
  'django_app' => {
    'settings_file' => 'local'
  },
  'owner' => 'vagrant',
  'group' => 'vagrant'
)
