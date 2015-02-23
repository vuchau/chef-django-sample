name 'development'
description 'The master development branch'

default_attributes(
  'root_dir' => '/src',
  'django_app' => {
    'settings_file' => 'local'
  },
  'owner' => 'vagrant',
  'group' => 'vagrant'
)
