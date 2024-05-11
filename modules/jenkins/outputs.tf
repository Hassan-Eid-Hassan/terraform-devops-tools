output "jenkins_instance_id" {
  value       = aws_instance.jenkins.id
  description = "ID of the Jenkins EC2 instance"
}

output "public_ip" {
  value       = aws_instance.jenkins.public_ip
  description = "Public IP of the Jenkins EC2 instance"
}
