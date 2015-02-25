name 'redis'
description 'Install redis server'

run_list(
  'recipe[apt]',
  'recipe[redisio]',
  'recipe[redisio::enable]'
)

default_attributes({
  'redisio' => {
    'servers' => [
      {'name' => 'master', 'port' => '6379', 'unixsocket' => '/tmp/redis.sock', 'unixsocketperm' => '755'},
    ]
  }
})
