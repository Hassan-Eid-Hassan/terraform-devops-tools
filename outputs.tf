output "nexus_public_ip" {
  value       = aws_instance.nexus.public_ip
  description = "Public IP of the Nexus EC2 instance"
}

output "nexus_public_dns" {
  value       = aws_instance.nexus.public_dns
  description = "Public DNS of the Nexus EC2 instance"
}
