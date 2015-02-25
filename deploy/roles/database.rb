name 'database'
description "A node hosting a database."
run_list(
    'recipe[build-essential]',
    'recipe[postgresql::server]',
    'recipe[webapp::database]'
)

override_attributes(
  'postgresql' => {
    'config' => {"listen_addresses" => '*'},
    'password' => {
      'postgres' => 'postgres_pass'
    }
  }
)
