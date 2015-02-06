name "vagrant"

run_list(
    # "recipe[openssl]",
    # "recipe[build-essential]",
    # "recipe[git]",
    # "recipe[python]",
    # "recipe[apt]",
    # "recipe[postgresql::server]",
    "recipe[webapp]",
)

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
  'dbname' => 'example',
  'user' => 'vagrant'
)
