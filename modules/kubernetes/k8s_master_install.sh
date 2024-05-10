#!/bin/bash

set -e  # Exit script on any command failure

# Constants
POD_NETWORK_URL="https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml"
K8S_REPO_URL="https://pkgs.k8s.io/core:/stable:/v1.29/rpm/"
K8S_GPG_KEY="https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key"
POD_NETWORK_CIDR="192.168.0.0/16"
LOG_FILE="/var/log/k8s_install.log"
AUTO_HASH_SWAP="false"

# Usage function
usage() {
    echo "Usage: $0"
    echo "This script installs Kubernetes master on a new server."
    echo "Logs are stored at $LOG_FILE"
}

# Function to log output to file
log_output() {
    exec &> >(tee -a "$LOG_FILE")
}

# Function to install Docker
install_docker() {
    echo "Installing Docker..."
    yum install -y yum-utils dnf iproute-tc
    yum install -y docker
    systemctl enable --now docker
    echo "Docker installation completed."
}

# Function to configure Docker
configure_docker() {
    echo "Configuring Docker..."
    cat <<EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  }
}
EOF
    systemctl restart docker
    echo "Docker configuration completed."
}

# Function to install Kubernetes
install_k8s() {
    echo "Installing Kubernetes..."
    cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=$K8S_REPO_URL
enabled=1
gpgcheck=0
gpgkey=$K8S_GPG_KEY
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
    sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
    sudo systemctl enable --now kubelet
    echo "Kubernetes installation completed."
}

# Configure containerd
configure_containerd() {
    echo "Configure containerd..."

    mkdir -p /etc/containerd
    containerd config default > /etc/containerd/config.toml
    systemctl restart containerd

    echo "Containerd configured."
}

# Function to initialize Kubernetes
initialize_k8s() {
    echo "Initializing Kubernetes cluster..."
    kubeadm init --pod-network-cidr "$POD_NETWORK_CIDR"

    mkdir -p $HOME/.kube
    cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    chown $(id -u):$(id -g) $HOME/.kube/config
    export KUBECONFIG=/etc/kubernetes/admin.conf

    echo "Kubernetes cluster initialized."
}

# Function to apply Pod network
apply_pod_network() {
    echo "Applying Pod network..."
    kubectl apply -f $POD_NETWORK_URL
    echo "Pod network applied."
}

print_join_command() {
    echo "Fetching join command for worker nodes..."
    # Retrieve the join command from kubeadm
    join_command=$(kubeadm token create --print-join-command)
    
    # Print the join command
    echo "Use the following command to join worker nodes to the cluster:"
    echo "$join_command" > /tmp/join_command.txt
}

# Main function to execute all steps
main() {
    log_output
    echo "Starting Kubernetes master installation..."
    
    echo "Step 1: Removing old versions..."
    yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine podman runc kube* -y

    echo "Step 2: Disabling SELinux..."
    setenforce 0
    sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

    echo "Step 3: Setting bridged packets to traverse iptables rules..."
    cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
    echo 1 > /proc/sys/net/ipv4/ip_forward
    sysctl --system

    echo "Step 4: Disabling all memory swaps..."
    swapoff -a
    if [ $AUTO_HASH_SWAP == "true" ]
    then
        sed -i '/\sswap\s/s/^/#/' /etc/fstab
    fi 
    echo "Please check any swap entries in /etc/fstab."

    echo "Step 5: Enabling transparent masquerading and VxLAN..."
    modprobe br_netfilter

    # Install Docker and Kubernetes
    install_docker
    configure_docker
    install_k8s
    configure_containerd

    echo "Step 6: Initializing Kubernetes..."
    initialize_k8s
    apply_pod_network

    # Fetch and print the join command
    print_join_command

    echo "Installation completed successfully."
}

# Run the main function
main