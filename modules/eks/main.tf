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

resource "aws_instance" "kubectl-server" {
    ami                         = var.helper_node_ami_id
    key_name                    = var.key_name
    instance_type               = var.helper_instance_type
    associate_public_ip_address = true
    subnet_id                   = var.subnet_ids[0]
    vpc_security_group_ids      = [var.security_group_id]

    tags = {
        Name = "helper_node"
    }
}

resource "aws_eks_node_group" "node-grp" {
    cluster_name    = aws_eks_cluster.eks.name
    node_group_name = var.node_group_name
    node_role_arn   = aws_iam_role.worker.arn
    subnet_ids      = var.subnet_ids
    capacity_type   = "ON_DEMAND"
    disk_size       = 20
    instance_types  = var.node_group_instance_type

    remote_access {
        ec2_ssh_key               = var.key_name
        source_security_group_ids = [var.security_group_id]
    }

    labels = {
        env = "dev"
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