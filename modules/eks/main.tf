#Creating EKS Cluster
resource "aws_eks_cluster" "eks" {
  name     = var.eks_cluster_name
  version  = var.eks_cluster_version
  role_arn = aws_iam_role.master.arn

  vpc_config {
    subnet_ids = var.eks_subnet_ids
  }

  tags = {
    "Name" = var.eks_cluster_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}

#Adding security group for EKS
resource "aws_security_group" "eks_sg" {
  name   = "${var.eks_cluster_name}-security-group"
  vpc_id = var.eks_sg_vpc_id

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
    Name = "${var.eks_cluster_name}-security-group"
  }
}

# resource "aws_launch_template" "eks_node_group_template" {
#   depends_on = [aws_eks_cluster.eks]
#   name       = "${var.eks_cluster_name}-node-group-template"
#   image_id   = var.eks_node_group_ami_id
#   key_name   = var.key_name

#   block_device_mappings {
#     device_name = "/dev/xvda" # The device name for the root volume
#     ebs {
#       volume_size = var.eks_node_group_disk_size
#     }
#   }

#   network_interfaces {
#     associate_public_ip_address = true
#     security_groups             = [aws_security_group.eks_sg.id]
#   }

#   tags = {
#     Name = "${var.eks_cluster_name}-node-group-template"
#   }
# }

resource "aws_eks_node_group" "node_group" {
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_eks_cluster.eks
  ]
  cluster_name    = var.eks_cluster_name
  node_group_name = "${var.eks_cluster_name}-node-group"
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = var.eks_subnet_ids
  capacity_type   = var.eks_node_group_capacity_type
  disk_size       = var.eks_node_group_disk_size
  instance_types  = var.eks_node_group_instance_type

  # launch_template {
  #   id      = aws_launch_template.eks_node_group_template.id
  #   version = aws_launch_template.eks_node_group_template.latest_version
  # }

  remote_access {
    ec2_ssh_key               = var.key_name
    source_security_group_ids = [aws_security_group.eks_sg.id]
  }

  scaling_config {
    desired_size = var.eks_node_group_desired_size
    max_size     = var.eks_node_group_max_size
    min_size     = var.eks_node_group_min_size
  }

  update_config {
    max_unavailable = var.eks_node_group_max_unavailable
  }

  tags = {
    Name = "${var.eks_cluster_name}-node-group"
  }
}

resource "aws_instance" "eks_helper_node" {
  depends_on                  = [aws_eks_cluster.eks, aws_eks_node_group.node_group, aws_security_group.eks_sg]
  iam_instance_profile        = aws_iam_instance_profile.eks_helper_node_instance_profile.name
  ami                         = var.eks_helper_node_ami_id
  key_name                    = var.key_name
  instance_type               = var.eks_helper_instance_type
  associate_public_ip_address = true
  subnet_id                   = var.eks_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.eks_sg.id]

  tags = {
    Name = "${var.eks_cluster_name}-helper-node"
  }

  user_data = templatefile("${path.module}/eks_helper_node_configure.tftpl", {
    eks_cluster_name = var.eks_cluster_name,
    eks_region_code  = var.eks_region_code
  })
}
