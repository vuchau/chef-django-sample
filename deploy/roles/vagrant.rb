name "vagrant"

run_list(
    "recipe[webapp::default]",
    "recipe[webapp::development]",
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
  'user' => 'vagrant',
  'django_application' => {
    'setting_file'=> 'local',
    'port'=> '8001',
  }
)
