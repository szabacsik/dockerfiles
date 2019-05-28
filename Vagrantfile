Vagrant.configure("2") do |config|
    config.vm.box = "szabacsik/ubuntu"
    config.vm.box_version = "1.0.0"
    config.vm.provider "virtualbox"
    config.vm.network "private_network", ip: "192.168.200.200"
    config.vm.hostname = "builder"
    config.vm.define "builder"
    config.vm.provider :virtualbox do |vb|
        vb.name = "builder"
        vb.memory = 2048
        vb.cpus = 2
    end
    config.ssh.username="worker"
    config.ssh.password="worker"
end