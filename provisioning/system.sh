#!/usr/bin/env bash

sudo timedatectl set-timezone Europe/Athens

sudo sed -i -e 's,    SendEnv LANG LC_*,#   SendEnv LANG LC_*,g' /etc/ssh/ssh_config
sudo service ssh restart

sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get -y install language-pack-en
sudo update-locale LC_ALL=en_US.UTF-8
sudo update-locale LANGUAGE=en_US.UTF-8

echo "Remove apt-daily"
echo 'APT::Periodic::Enable "0";' > /etc/apt/apt.conf.d/10cloudinit-disable
sudo apt-get -y purge update-notifier-common ubuntu-release-upgrader-core landscape-common unattended-upgrades

sudo apt-get -y autoremove
sudo apt-get -y clean