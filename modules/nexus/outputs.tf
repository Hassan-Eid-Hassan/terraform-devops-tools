output "nexus_instance_id" {
  value       = aws_instance.nexus.id
  description = "ID of the Nexus EC2 instance"
}

output "public_ip" {
  value       = aws_instance.nexus.public_ip
  description = "Public IP of the Nexus EC2 instance"
}
