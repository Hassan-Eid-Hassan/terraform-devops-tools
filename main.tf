# VPC module
module "vpc" {
  source = "./modules/vpc"
  vpc_name = var.vpc_name
  igw_name = var.igw_name
  router_table_name = var.router_table_name
  vpc_cidr_block = var.vpc_cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs = var.azs

}

#Adding security group for EKS
resource "aws_security_group" "eks_sg" {
  depends_on = [ module.vpc ]
  name = "eks-security-group"
  vpc_id        = module.vpc.vpc_id

  ingress {
      description = "TLS from VPC"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EKS-SG"
  }
}

# Security group for Jenkins
resource "aws_security_group" "jenkins_sg" {
  depends_on = [ module.vpc ]
  vpc_id = module.vpc.vpc_id
  name = "jenkins-security-group"

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
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

# Security group for Nexus
resource "aws_security_group" "nexus_sg" {
  depends_on = [ module.vpc ]
  vpc_id = module.vpc.vpc_id
  name = "nexus-security-group"

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
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

# Jenkins module
module "jenkins" {
  source = "./modules/jenkins"
  depends_on = [ aws_security_group.jenkins_sg, module.vpc ]
  jenkins_instance_type   = var.jenkins_instance_type
  jenkins_ami_id          = var.jenkins_ami_id
  key_name        = var.key_name
  jenkins_subnet_id = module.vpc.public_subnet_id[0]
  jenkins_security_group_id = aws_security_group.jenkins_sg.id
  jenkins_vpc_id          = module.vpc.vpc_id
  ssh_key_path    = var.ssh_key_path
  jenkins_instance_user = var.jenkins_instance_user
}

# Nexus module
module "nexus" {
  source = "./modules/nexus"
  depends_on = [ aws_security_group.nexus_sg, module.vpc ]
  nexus_instance_type   = var.nexus_instance_type
  nexus_ami_id          = var.nexus_ami_id
  key_name        = var.key_name
  nexus_subnet_id       = module.vpc.public_subnet_id[0]
  nexus_security_group_id = aws_security_group.nexus_sg.id
  nexus_vpc_id          = module.vpc.vpc_id
  ssh_key_path    = var.ssh_key_path
  nexus_instance_user = var.nexus_instance_user
}

# EKS module
module "eks" {
    source = "./modules/eks"
    depends_on = [ module.vpc ]
    cluster_name = var.cluster_name
    eks_version = var.eks_version
    subnet_ids = module.vpc.public_subnet_id
    helper_node_ami_id = var.helper_node_ami_id
    helper_instance_type = var.helper_instance_type
    node_group_name = var.node_group_name
    node_group_instance_type = var.node_group_instance_type
    min_size = var.min_size
    max_size = var.max_size
    desired_size = var.desired_size
    key_name = var.key_name
    security_group_id = aws_security_group.eks_sg.id
    node_group_ami_id = var.node_group_ami_id
    disk_size = var.desired_size
    capacity_type = var.capacity_type
    eks_node_group_template_name = var.eks_node_group_template_name
    eks_helper_node_name = var.eks_helper_node_name
}