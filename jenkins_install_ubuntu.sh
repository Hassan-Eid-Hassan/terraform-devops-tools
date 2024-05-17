#!/bin/bash

# Install Java 17
echo "Installing Java 17..."
sudo apt update -y
sudo apt install -y openjdk-17-jdk
echo "Java 17 installed."

# Add Jenkins repository and key
echo "Adding Jenkins repository..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key || true
sudo echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null || true

# Install Jenkins
echo "Installing Jenkins..."
sudo apt update -y
sudo apt install -y jenkins

# Start and enable Jenkins service
echo "Starting and enabling Jenkins service..."
sudo systemctl enable --now jenkins

echo "Installing Git..."
# Install Git
sudo yum install -y git 

# Provide instructions to the user to access Jenkins
echo "Find the initial admin password in /var/lib/jenkins/secrets/initialAdminPassword"

# Allow Jenkins port (8080) in UFW firewall
echo "Configuring firewall..."
if sudo ufw status | grep -q inactive; then
    sudo ufw enable
fi
sudo ufw allow 8080/tcp