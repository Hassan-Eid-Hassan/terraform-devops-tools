# Output the public IP address of the Kubernetes master node
output "k8s_master_public_ip" {
  description = "Public IP address of the Kubernetes master node."
  value       = aws_instance.k8s_master.public_ip
}
