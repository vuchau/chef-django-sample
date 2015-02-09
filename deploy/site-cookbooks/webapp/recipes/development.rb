# For vagrant
template "/home/vagrant/.bashrc" do
    source "bashrc.erb"
    owner "vagrant"
end
