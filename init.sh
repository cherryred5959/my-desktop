#! /bin/bash

# Kakao Mirror
sudo sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com\/ubuntu/g' /etc/apt/sources.list 
sudo apt-get update

# Nimf & Korean Font
sudo add-apt-repository ppa:hodong/nimf -y
sudo apt-get update
sudo apt-get install nimf nimf-libhangul fonts-nanum fonts-nanum-coding fonts-nanum-extra -y

# Docker
sudo apt-get install docker.io -y
sudo usermod -aG docker $USER
sudo systemctl start docker
sudo systemctl enable docker
sudo apt-get install docker-compose -y

# Git
sudo apt-get install git

# Keyboard
sudo cp ./xkorkeymap /etc/init.d/xkorkeymap 
sudo chmod +x /etc/init.d/xkorkeymap
sudo update-rc.d xkorkeymap defaults

exit 0
