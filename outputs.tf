output "jenkins_public_ip" {
    value = module.jenkins.public_ip
    description = "Public IP of the Jenkins instance"
}

output "jenkins_url" {
    value = "http://${module.jenkins.public_ip}:8080"
    description = "Public IP of the Nexus instance"
}

output "nexus_public_ip" {
    value = module.nexus.public_ip
    description = "Public IP of the Nexus instance"
}

output "nexus_url" {
    value = "http://${module.nexus.public_ip}:8081"
    description = "Public IP of the Nexus instance"
}

output "eks_endpoint" {
    value = module.eks.eks_endpoint
    description = "The endpoint for the EKS cluster."
}

# Output the public IP address of the Kubernetes master node
output "k8s_master_public_ip" {
    description = "Public IP address of the Kubernetes master node."
    value       = module.Kubernetes.k8s_master_public_ip
}
