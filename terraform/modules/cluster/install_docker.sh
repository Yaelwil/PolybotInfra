#!/bin/bash

# Update package list
sudo apt update -y

# Install required packages with auto-approve
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker's APT repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update package list again to include Docker's repository
sudo apt update -y

# Install Docker CE with auto-approve
sudo apt install -y docker-ce

# Start Docker
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker

# Add current user to the Docker group
sudo usermod -aG docker $USER
newgrp docker
# Reboot the system
# sudo reboot
