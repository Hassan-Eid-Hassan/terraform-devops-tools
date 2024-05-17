#!/bin/bash

NEXUS_URL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"
INSTALL_DIR="/opt/nexus"
NEXUS_USER="nexus"
NEXUS_GROUP="nexus"
NEXUS_SERVICE="/etc/systemd/system/nexus.service"

# Function to create a Nexus user and group

echo "Creating Nexus user and group..."
sudo groupadd $NEXUS_GROUP || true
sudo useradd -r -g $NEXUS_GROUP -d $INSTALL_DIR -s /sbin/nologin $NEXUS_USER || true
echo "Nexus user and group created."

# Function to install Java 1.8

echo "Installing Java 1.8..."
sudo yum update -y
sudo yum install -y java-1.8.0-amazon-corretto
echo "Java 1.8 installed."


# Function to download and extract Nexus

echo "Downloading Nexus..."
sudo wget -q $NEXUS_URL -O /tmp/nexus.tar.gz
echo "Extracting Nexus..."
sudo mkdir -p $INSTALL_DIR
sudo tar -xzf /tmp/nexus.tar.gz -C $INSTALL_DIR
sudo echo "Nexus installed in $INSTALL_DIR."


# Function to configure Nexus

echo "Configuring Nexus..."
sudo mv $INSTALL_DIR/nexus-3* $INSTALL_DIR/nexus
sudo chown -R $NEXUS_USER:$NEXUS_GROUP $INSTALL_DIR
sudo echo "run_as=$NEXUS_USER" > "$INSTALL_DIR/nexus/bin/nexus.rc"
echo "Nexus configured."


# Function to create Nexus systemd service

echo "Creating Nexus systemd service..."
sudo tee $NEXUS_SERVICE > /dev/null << EOF
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=$NEXUS_USER
Group=$NEXUS_GROUP
ExecStart=$INSTALL_DIR/nexus/bin/nexus start
ExecStop=$INSTALL_DIR/nexus/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable nexus
echo "Nexus service created and enabled."


# Function to start Nexus

echo "Starting Nexus..."
sudo systemctl start nexus
echo "Nexus started."


# Function to display Nexus admin password

echo "Nexus installation completed successfully."
echo "You can access Nexus at http://localhost:8081/"
echo "To log in as admin, find the admin password here:"
echo "$INSTALL_DIR/sonatype-work/nexus3/admin.password"