name "base"
description "Base role applied to all nodes."

run_list(
  "recipe[apt]",
  "recipe[build-essential]",
  "recipe[git]",
  "recipe[vim]",
  "recipe[postgresql::server]"
)

default_attributes(
  'build-essential' => {
    'compile_time' => true
  }
)
