name 'celery'
description 'Install celery'

run_list(
  "recipe[apt]",
  "recipe[python]",
  "recipe[nginx]",
  "recipe[supervisor]",
  "recipe[webapp]",
  "recipe[webapp::deployment]",
  "recipe[webapp::celery]"
)
