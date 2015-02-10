root = File.absolute_path(File.dirname(__FILE__))
file_cache_path    "/var/chef/cache"
file_backup_path   "/var/chef/backup"
cookbook_path ["cookbooks", "site-cookbooks"]
role_path "roles"
data_bag_path "data_bags"
log_level :info
verbose_logging    false
encrypted_data_bag_secret nil


