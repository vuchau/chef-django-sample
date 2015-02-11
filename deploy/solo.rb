root = File.absolute_path(File.dirname(__FILE__))
file_cache_path '/var/chef/cache'
file_backup_path '/var/chef/backup'
cookbook_path ["#{root}/cookbooks", "#{root}/site-cookbooks"]
role_path "#{root}/roles"
data_bag_path "#{root}/data_bags"
log_level :info
verbose_logging    false
encrypted_data_bag_secret nil


