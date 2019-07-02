Vagrant.configure("2") do |config|
    config.vm.box = "szabacsik/ubuntu"
    #config.vm.box_version = "1.0.0"
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
    config.vm.synced_folder ".", "/vagrant", owner: "worker", group: "worker", :mount_options => ["dmode=777", "fmode=700", "uid=1000", "gid=1000"]
end