name "vagrant"

run_list(
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
