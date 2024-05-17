# Security group for Nexus
resource "aws_security_group" "nexus_sg" {
  vpc_id = var.nexus_sg_vpc_id
  name   = "nexus-security-group"

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
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = var.http_cidr_blocks
  }

  tags = {
    Name = "Nexus-SG"
  }
}

resource "aws_instance" "nexus" {
  ami                    = var.nexus_ami_id
  instance_type          = var.nexus_instance_type
  subnet_id              = var.nexus_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.nexus_sg.id]

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "Nexus"
  }

  user_data = var.nexus_linux_distribution == "aws-linux" ? file("${path.module}/nexus_install_aws-linux.sh") : file("${path.module}/nexus_install_ubuntu.sh")

}
