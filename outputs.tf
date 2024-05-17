output "jenkins_public_ip" {
  value       = aws_instance.jenkins.public_ip
  description = "Public IP of the Jenkins EC2 instance"
}

output "jenkins_public_dns" {
  value       = aws_instance.jenkins.public_dns
  description = "Public DNS of the Jenkins EC2 instance"
}
