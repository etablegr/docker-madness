Vagrant.configure("2") do |config|

    config.vm.box = "ubuntu/bionic64"
    config.vm.box_version = "20200325.0.0"
    config.vm.box_download_insecure = true

    config.vm.provider "virtualbox" do |vb|
        vb.name = "docker-madness"
        
        vb.memory = 512
        vb.cpus = 1
        
        vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
    end

    config.vm.network "private_network", ip: "192.168.10.7"
    config.vm.network "forwarded_port", guest: 80, host: 8887
    config.vm.network "forwarded_port", guest: 22, host: 2227

    config.vm.synced_folder "./code", "/home/vagrant/code", type: "nfs", mount_options: ["nolock"]

    config.vm.provision :shell, :path => "./provisioning/system.sh"
    config.vm.provision :shell, :path => "./provisioning/docker.sh"
    config.vm.provision :shell, :path => "./provisioning/cleanup.sh"  

    config.vm.provision :shell, :path => "./provisioning/docker-compose.sh", :run => "always", privileged: false
end