# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.define "Build Node" do |build_node|
    build_node.vm.network "private_network", ip: "192.168.50.7"
    build_node.vm.provision "shell", path: "build-node.sh"
    build_node.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "4096"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
  end

  config.vm.define "Chef Server" do |chef_server|
    chef_server.vm.network "private_network", ip: "192.168.50.5"
    chef_server.vm.provision "shell", path: "chef-server.sh"
    chef_server.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "8192"]
        vb.customize ["modifyvm", :id, "--cpus", "4"]
    end
  end

  config.vm.define "Delivery Server" do |delivery_server|
    delivery_server.vm.network "private_network", ip: "192.168.50.6"
    delivery_server.vm.provision "shell", path: "chef-delivery.sh"
    delivery_server.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "16384"]
        vb.customize ["modifyvm", :id, "--cpus", "4"]
    end
  end

end
