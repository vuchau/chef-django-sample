module WebappHelpers

  def globals_databagitem(databagitem)
    return Chef::DataBagItem.load('globals', databagitem)
  end

  def secrets_databagitem(databagitem)
    if node.default[:webapp][:data_bag][:encrypted]
      return Chef::EncryptedDataBagItem.load('secrets', databagitem)[node.chef_environment]
    else
      return Chef::DataBagItem.load('secrets', databagitem)[node.chef_environment]
    end
  end

  def get_db_name
    return databagitem('database')['db_name']
  end

  def get_db_user
    return databagitem('database')['db_user']
  end

  def get_db_pass
    return databagitem('database')['db_pass']
  end

  def get_db_host
    return databagitem('database')['db_host']
  end

  def get_db_port
    return databagitem('database')['db_port']
  end

  def get_db_root_password
    return databagitem('database')['root_password']
  end

  def get_app_name
  	return globals_databagitem('webapp_info')['app_name']
  end

end
