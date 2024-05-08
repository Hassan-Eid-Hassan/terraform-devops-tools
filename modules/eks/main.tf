#Creating EKS Cluster
resource "aws_eks_cluster" "eks" {
    name     = var.cluster_name
    version  = var.eks_version
    role_arn = aws_iam_role.master.arn

    vpc_config {
        subnet_ids = var.subnet_ids
    }

    tags = {
        "Name" = var.cluster_name
    }

    depends_on = [
        aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
        aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    ]
}

resource "aws_instance" "eks_helper_node" {
    ami                         = var.helper_node_ami_id
    key_name                    = var.key_name
    instance_type               = var.helper_instance_type
    associate_public_ip_address = true
    subnet_id                   = var.subnet_ids[0]
    vpc_security_group_ids      = [var.security_group_id]

    tags = {
        Name = var.eks_helper_node_name
    }
}

resource "aws_launch_template" "eks_node_group_template" {
    name          = var.eks_node_group_template_name
    image_id      = var.node_group_ami_id
    instance_type = [var.node_group_instance_type]

    key_name = var.key_name

    network_interfaces {
        associate_public_ip_address = true
        security_groups             = [var.security_group_id]
    }

    tags = {
      Name = var.eks_node_group_template_name
    }
}

resource "aws_eks_node_group" "node_group" {
    cluster_name    = aws_eks_cluster.eks.name
    node_group_name = var.node_group_name
    node_role_arn   = aws_iam_role.worker.arn
    subnet_ids      = var.subnet_ids
    capacity_type   = var.capacity_type
    disk_size       = var.disk_size
    instance_types  = var.node_group_instance_type

    launch_template {
        id      = aws_launch_template.eks_node_group_template.id
        version = aws_launch_template.eks_node_group_template.latest_version
    }

    remote_access {
        ec2_ssh_key               = var.key_name
        source_security_group_ids = [var.security_group_id]
    }

    scaling_config {
        desired_size = var.desired_size
        max_size     = var.max_size
        min_size     = var.min_size
    }

    update_config {
        max_unavailable = 1
    }

    depends_on = [
        aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    ]
}