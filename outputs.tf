output "jenkins_public_ip" {
    value = module.jenkins.jenkins_public_ip
    description = "Public IP of the Jenkins instance"
}

output "jenkins_url" {
    value = "http://${module.jenkins.jenkins_public_dns}:8080"
    description = "URL of the Jenkins instance"
}

output "nexus_public_ip" {
    value = module.jenkins.jenkins_public_ip
    description = "Public IP of the Nexus instance"
}

output "nexus_url" {
    value = "http://${module.jenkins.jenkins_public_dns}:8081"
    description = "URL of the Nexus instance"
}

output "eks_endpoint" {
    value = module.eks.eks_endpoint
    description = "The endpoint for the EKS cluster."
}

output "k8s_master_main_public_ip" {
    description = "Public IP address of the Kubernetes master node."
    value       = module.Kubernetes.k8s_master_main_public_ip
}