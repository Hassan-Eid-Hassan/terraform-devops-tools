resource "aws_s3_bucket" "kubernetes_cluster_bucket" {
  bucket = "${var.k8s_cluster_name}-bucket"
}

# Define IAM policy for S3 bucket access
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = [aws_s3_bucket.kubernetes_cluster_bucket.arn, "${aws_s3_bucket.kubernetes_cluster_bucket.arn}/*"]
  }
}

# Create IAM policy for S3 bucket access
resource "aws_iam_policy" "s3_bucket_policy" {
  name        = "${var.k8s_cluster_name}-bucket-policy"
  description = "IAM policy for accessing the ${var.k8s_cluster_name} Kubernetes cluster S3 bucket"
  policy      = data.aws_iam_policy_document.s3_bucket_policy.json
}

# Create IAM role for accessing the S3 bucket
resource "aws_iam_role" "s3_access_role" {
  name = "${var.k8s_cluster_name}-bucket-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "s3_bucket_policy_attachment" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.s3_bucket_policy.arn
}

# Create IAM instance profile for master and worker instances
resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "${var.k8s_cluster_name}-bucket-profile"
  role = aws_iam_role.s3_access_role.name # Use IAM role created earlier
}

resource "aws_security_group" "k8s_master_sg" {
  name        = "${var.k8s_cluster_name}-master-sg"
  description = "Security group for Kubernetes master node"
  vpc_id      = var.k8s_sg_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  # Add other necessary ports (e.g., Kubernetes ETCD server)
  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_cidrs[0]] # Adjust according to your network requirements
  }

  # Add other necessary ports (e.g., Kubernetes API server)
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust according to your network requirements
  }

  # Add other necessary ports (e.g., Kubernetes kubelet, kube-scheduler, and kube-controller)
  ingress {
    from_port   = 10250
    to_port     = 10259
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_cidrs[0]] # Adjust according to your network requirements
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.k8s_cluster_name}-master-sg"
  }
}

resource "aws_security_group" "k8s_worker_sg" {
  name        = "${var.k8s_cluster_name}-worker-sg"
  description = "Security group for Kubernetes worker nodes"
  vpc_id      = var.k8s_sg_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  # Allow communication from the master node and other worker nodes
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_cidrs[0]]
  }

  # Node Port Rang
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.k8s_cluster_name}-worker-sg"
  }
}

resource "aws_instance" "k8s_master" {
  depends_on             = [aws_security_group.k8s_master_sg, aws_iam_instance_profile.s3_access_profile]
  ami                    = var.k8s_master_ami_id
  instance_type          = var.k8s_master_instance_type
  subnet_id              = var.k8s_master_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.k8s_master_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.s3_access_profile.name # Attach IAM role to instance

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name   = "${var.k8s_cluster_name}-master"
    Role   = "master"
    Module = "k8s-cluster"
  }

  user_data = templatefile("${path.module}/k8s_master_install.tftpl", {
    k8s_cluster_name = var.k8s_cluster_name
  })
}

resource "aws_launch_template" "worker-lt" {
  depends_on    = [aws_instance.k8s_master, aws_security_group.k8s_worker_sg]
  name          = "${var.k8s_cluster_name}-worker-lt"
  image_id      = var.k8s_worker_ami_id
  instance_type = var.k8s_worker_instance_type
  key_name      = var.key_name

  block_device_mappings {
    device_name = "/dev/xvda" # The device name for the root volume
    ebs {
      volume_size = 30
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.s3_access_profile.name # Attach IAM role to instance
  }

  # Use dynamic block to handle security groups since it can be a list
  network_interfaces {
    associate_public_ip_address = true # Associate public IP address

    # Specify the security groups
    security_groups = [aws_security_group.k8s_worker_sg.id]
  }

  user_data = base64encode(templatefile("${path.module}/k8s_worker_install.tftpl", {
    k8s_cluster_name = var.k8s_cluster_name
  }))

}

resource "aws_autoscaling_group" "worker-asg" {
  depends_on          = [aws_launch_template.worker-lt]
  name                = "${var.k8s_cluster_name}-worker-asg"
  min_size            = var.k8s_worker_min_capacity
  max_size            = var.k8s_worker_max_capacity
  desired_capacity    = var.k8s_worker_desired_capacity
  vpc_zone_identifier = [var.k8s_worker_subnet_id]

  launch_template {
    id      = aws_launch_template.worker-lt.id
    version = aws_launch_template.worker-lt.latest_version
  }
  tag {
    key                 = "Name"
    value               = "${var.k8s_cluster_name}-worker"
    propagate_at_launch = true
  }
  tag {
    key                 = "Role"
    value               = "worker"
    propagate_at_launch = true
  }
  tag {
    key                 = "Module"
    value               = "k8s-cluster"
    propagate_at_launch = true
  }
}
