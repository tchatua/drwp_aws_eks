#!/bin/bash

# Update and install packages
sudo apt update -y
sudo apt install -y nginx telnet git

# Enable and start nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Prepare web directories
sudo mkdir -p /var/www/html/app1
sudo chmod -R 755 /var/www/html

# Clone your GitHub repo
cd /tmp
git clone https://github.com/tchatua/TinDogProjectWebsite.git

# Deploy website
sudo cp -pr TinDogProjectWebsite/* /var/www/html/
sudo cp -pr TinDogProjectWebsite/* /var/www/html/app1/
