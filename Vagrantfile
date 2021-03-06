# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

$rootScript = <<SCRIPT
  wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
  sudo dpkg -i erlang-solutions_1.0_all.deb
  sudo apt-get update -y
  sudo apt-get install -y git
  sudo apt-get install -y librarian-puppet
  sudo apt-get install -y autotools-dev
  sudo apt-get install -y automake
  sudo apt-get install -y python-dev
  sudo cp /home/vagrant/puppet/Puppetfile /etc/puppet
  cd /etc/puppet && librarian-puppet install --verbose
  mkdir -p /etc/nginx/sites-available
  mkdir -p /etc/nginx/sites-enabled

SCRIPT

$userScript = <<SCRIPT
  cd /home/vagrant
  wget -qO- https://raw.github.com/creationix/nvm/master/install.sh | sh
  export NVM_DIR="/home/vagrant/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
  nvm install 4.4.0
  nvm alias default 4.4.0
  npm -g install npm@latest
  npm install -g bower ember-cli
  
  if ! grep -qe "^export NVM_DIR" "/home/vagrant/.bashrc"; then
	echo '' >> /home/vagrant/.bashrc  
	echo '# Adding NVM setup' >> /home/vagrant/.bashrc  
    echo 'export NVM_DIR="/home/vagrant/.nvm"' >> /home/vagrant/.bashrc  
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> /home/vagrant/.bashrc  
	echo '' >> /home/vagrant/.bashrc  
  fi

  git clone https://github.com/facebook/watchman.git
  cd watchman
  git checkout v4.5.0  # the latest stable release
  ./autogen.sh
  ./configure
  make
  sudo make install
  sudo sysctl fs.inotify.max_user_watches=524288
  
    
  mkdir -p /srv/www/ember-phoenix-starter-app-box/client/node_modules
  mkdir -p /srv/www/ember-phoenix-starter-app-box/client/bower_components
  mkdir -p /home/vagrant/client_node_modules
  mkdir -p /home/vagrant/client_bower_components
  
  
  if ! grep -qe "^mount --bind ~/client_node_modules" "/home/vagrant/.bashrc"; then
	echo ''  >> /home/vagrant/.bashrc  
	echo "# mounting ~/client_node_modules" >> /home/vagrant/.bashrc 
    echo 'sudo mount --bind ~/client_node_modules /srv/www/ember-phoenix-starter-app-box/client/node_modules' >> /home/vagrant/.bashrc  
    echo 'sudo mount --bind ~/client_bower_components /srv/www/ember-phoenix-starter-app-box/client/bower_components' >> /home/vagrant/.bashrc  
	echo ''  >> /home/vagrant/.bashrc  
  fi
SCRIPT


Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 3000
  config.vm.network "forwarded_port", guest: 49152, host: 49152

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "manifests", "/home/vagrant/puppet"
  config.vm.synced_folder "www", "/srv/www", type: "rsync", rsync__exclude: ".git/", rsync__auto: "true"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  
  config.vm.provision "shell", inline: $rootScript
  config.vm.provision "shell", inline: $userScript, privileged: false
    
  config.vm.provision :puppet
end
