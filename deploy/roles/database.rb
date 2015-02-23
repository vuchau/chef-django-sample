name 'database'

run_list(
    'recipe[postgresql::server]',
    'recipe[webapp::database]'
)

override_attributes(
  'postgresql' => {
    'config' => {"listen_addresses" => '*'},
    'password' => 'postgres'
  }
)
