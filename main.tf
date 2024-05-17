# Security group for Jenkins
resource "aws_security_group" "jenkins_sg" {
  vpc_id = var.jenkins_sg_vpc_id
  name   = "jenkins-security-group"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.http_cidr_blocks
  }

  tags = {
    Name = "Jenkins-SG"
  }
}

resource "aws_instance" "jenkins" {
  ami                    = var.jenkins_ami_id
  instance_type          = var.jenkins_instance_type
  subnet_id              = var.jenkins_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "Jenkins"
  }

  user_data = var.jenkins_linux_distribution == "aws-linux" ? file("${path.module}/jenkins_install_aws-linux.sh") : file("${path.module}/jenkins_install_ubuntu.sh")

}