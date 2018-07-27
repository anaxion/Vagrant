# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|


  config.vm.box = "centos/7"

  config.vm.network "private_network", ip: "192.168.56.200"

  config.vm.provision "shell", path: "scenario.sh",
    run: "always"
   
end
