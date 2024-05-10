# Output the public IP address of the Kubernetes master node
output "k8s_master_public_ip" {
    description = "Public IP address of the Kubernetes master node."
    value       = aws_instance.k8s_master.public_ip
}

# Output the join command from the master node
output "k8s_join_command" {
    description = "Kubernetes join command from the master node."
    value       = data.external.join_command.result.output
}

# Output the public IP addresses of the worker nodes
output "k8s_worker_public_ips" {
    description = "Public IP addresses of the Kubernetes worker nodes."
    value       = [for i in aws_instance.k8s_worker : i.public_ip]
}
