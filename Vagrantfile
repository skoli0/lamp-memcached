# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Vagrant VM box, a shorthand name of a box in HashiCorp's Vagrant Cloud.
  config.vm.box = "boxcutter/ubuntu1604-desktop"

  # SSH communicator type to use to connect to the guest box.
  config.vm.communicator = "ssh"
  # The time in seconds that Vagrant will wait for the machine to gracefully halt when vagrant halt is called.
  config.vm.boot_timeout = 600
  # The guest OS that will be running within this machine.
  config.vm.guest = :linux
  
  # The username and password that Vagrant will SSH as by default.
  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"

  # Configure provider-specific configuration, which is used to modify settings which are specific to a certain provider.
  config.vm.provider :virtualbox do |vb, override|
    vb.name = "Ubuntu16.04"
    vb.gui = true
    #override.vm.box_url = "C:/Users/Sandeep_Koli/Desktop//ubuntu1604-desktop-2.0.26.box"
    vb.memory = "2048"
  end
  
  # Vagrant will check for updates to the configured box on every vagrant up.
  config.vm.box_check_update = true

  # Define name of vagrant box.
  config.vm.define "Ubuntu16.04" do |vm|
  end

  # The shell to use when executing SSH commands from Vagrant.
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  # Agent forwarding over SSH connections is enabled.
  config.ssh.forward_agent = true
  # Configure the networks on the machine, by port forwarding.
  config.vm.network "forwarded_port", guest: 80, host: 8080
  
  # Configure provisioners on the machine, so that software can be automatically installed and configured 
  # when the machine is created.
  
  # configure_apache_http: Installs Apache2 and configures it to HTTP, by default. Opens a web link, http://localhost:8080/app
  config.vm.provision "configure_apache_http", type:"shell", path: "configure_apache_http.sh"
  
  # configure_apache_http: Reconfigure Apache2 to run using HTTPS rather than HTTP
  config.vm.provision "configure_apache_https", type:"shell", path: "configure_apache_https.sh"
  
  # open_app_https: Opens a test page with HTTPS by going in browser at https://localhost:8443/app
  config.vm.provision "open_app_https", type:"shell", path: "open_app_https.sh", privileged: false
  
  # configure_memcached: Installs and configures memcached, a high-performance memory object caching system service
  config.vm.provision "configure_memcached", type:"shell", path: "configure_memcached.sh"
  
  # configure_cronjob: Adds a cronjob that runs /home/vagrant/exercise-memcached.sh once per minute 
  config.vm.provision "configure_cronjob", type:"shell", path: "configure_cronjob.sh", privileged: false
  
  # upload_app_tar: Uploads pre-created and configured app site to /tmp in machine
  config.vm.provision "upload_app_tar", type: "file", source: "app.tar.gz", destination: "/tmp/app.tar.gz"
  
  # configure_memcached_app: Configure memcached web app
  config.vm.provision "configure_memcached_app", type:"shell", path: "configure_memcached_app.sh"
  
  # open_memcached_app_http: Opens memcached link, either http://localhost:8080/app or https://localhost:8443/app
  # The reason we are not opening HTTPS link because it requires to add exception manually. We want to see the memcached
  # monitoring web page automatically, don't we?
  config.vm.provision "open_app_http", type:"shell", path: "open_app_http.sh", privileged: false
  
  # Example of inline script
  #config.vm.provision "open_app_http", type:"shell", privileged: false, inline: <<-SHELL
  #  set -x
  #  export DISPLAY=:0.0
  #  sh -c "xdg-open http://localhost:8080/app & > /dev/null 2>&1"
  #SHELL
  
end

