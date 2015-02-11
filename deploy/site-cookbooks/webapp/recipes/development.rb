# For vagrant
template "/home/vagrant/.bash_profile" do
    source "bash_profile.erb"
    owner node[:owner]
end
