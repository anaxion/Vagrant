# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
    config.vm.define "ans" do |ans|
      ans.vm.box = "centos/7"   
      ans.vm.network "forwarded_port", guest: 80, host: 8080
      ans.vm.network "private_network", ip: "192.168.56.200"
      ans.vm.provision "shell", path: "ansible.sh"
      ans.vm.provision "file", source: ".vagrant/machines/anx/virtualbox/private_key", destination: "/home/vagrant/machines/anx.private_key"
      ans.vm.provision "file", source: ".vagrant/machines/anx2/virtualbox/private_key", destination: "/home/vagrant/machines/anx2.private_key"
      ans.vm.provision "shell", inline: "chmod 0600 /home/vagrant/machines/anx.private_key"
      ans.vm.provision "shell", inline: "chmod 0600 /home/vagrant/machines/anx2.private_key"
      ans.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "web_db.yml"
      ansible.verbose = true
      ansible.install = true
      ansible.limit = "all"
      ansible.inventory_path = "hosts"
        end
          ans.vm.provider "virtualbox" do |vb|
          vb.memory = "1024"
          end  
    end
    config.vm.define "anx" do |anx|
      anx.vm.box = "centos/7"
      anx.vm.network "private_network", ip: "192.168.56.201"
        anx.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        end
    end
    config.vm.define "anx2" do |anx2|
      anx2.vm.box = "centos/7"
      anx2.vm.network "private_network", ip: "192.168.56.202"
        anx2.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        end
    end 
end