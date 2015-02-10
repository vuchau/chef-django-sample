name "web_server"
description "A node hosting a running Django/gunicorn process"

run_list(
    "recipe[webapp]"
)
