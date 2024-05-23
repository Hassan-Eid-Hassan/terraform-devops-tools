# S3 ##################################################################
resource "aws_s3_bucket" "kubernetes_cluster_bucket" {
  bucket = "${var.k8s_cluster_name}-bucket"
}

# Define IAM policy for S3 bucket access
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = [aws_s3_bucket.kubernetes_cluster_bucket.arn, "${aws_s3_bucket.kubernetes_cluster_bucket.arn}/*"]
  }
  statement {
    actions   = ["ec2:CreateTags"]
    resources = ["*"]
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
#########################################################################
# Security group ########################################################

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

  # Add other necessary ports (e.g., Kubernetes API server)
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust according to your network requirements
  }

  # Allow all inbound traffic within the k8s subnet
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_subnet_cidrs[0]] # Adjust according to your network requirements
  }

  # Allow inbound HTTPS traffic (NodePort fo Traefik)
  ingress {
    from_port   = 32443
    to_port     = 32443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust according to your network requirements
  }

  # Allow inbound HTTP traffic (NodePort fo Traefik)
  ingress {
    from_port   = 32080
    to_port     = 32080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust according to your network requirements
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

  # Allow all inbound traffic within the k8s subnet
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_subnet_cidrs[0]] # Adjust according to your network requirements
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Adjust according to your network requirements
  }

  tags = {
    Name = "${var.k8s_cluster_name}-worker-sg"
  }
}
#########################################################################
# LoadBalancer if HA k8s (masters > 1) ##################################

resource "aws_lb" "k8s_lb" {
  depends_on         = [aws_s3_bucket.kubernetes_cluster_bucket, aws_security_group.k8s_master_sg, aws_security_group.k8s_worker_sg]
  count              = var.k8s_number_of_master_nodes > 1 ? 1 : 0
  name               = "${var.k8s_cluster_name}-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [var.k8s_master_subnet_id[0]]

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.k8s_cluster_name}-lb"
  }
}

resource "aws_lb_target_group" "k8s_api_tg" {
  depends_on  = [aws_lb.k8s_lb]
  count       = var.k8s_number_of_master_nodes > 1 ? 1 : 0
  name        = "${var.k8s_cluster_name}-api-tg"
  target_type = "instance"
  port        = 6443
  protocol    = "TCP"
  vpc_id      = var.k8s_sg_vpc_id
}

resource "aws_lb_target_group" "k8s_http_apps_tg" {
  depends_on  = [aws_lb.k8s_lb]
  count       = var.k8s_number_of_master_nodes > 1 ? 1 : 0
  name        = "${var.k8s_cluster_name}-http-tg"
  target_type = "instance"
  port        = 32080
  protocol    = "TCP"
  vpc_id      = var.k8s_sg_vpc_id
}

resource "aws_lb_target_group" "k8s_https_apps_tg" {
  depends_on  = [aws_lb.k8s_lb]
  count       = var.k8s_number_of_master_nodes > 1 ? 1 : 0
  name        = "${var.k8s_cluster_name}-https-tg"
  target_type = "instance"
  port        = 32443
  protocol    = "TCP"
  vpc_id      = var.k8s_sg_vpc_id
}

resource "aws_lb_target_group_attachment" "k8s_tg_attachment" {
  count = var.k8s_number_of_master_nodes > 1 ? 3 : 0
  target_group_arn = element(
    [
      aws_lb_target_group.k8s_api_tg[0].arn,
      aws_lb_target_group.k8s_http_apps_tg[0].arn,
      aws_lb_target_group.k8s_https_apps_tg[0].arn
    ],
    count.index
  )
  target_id = aws_instance.k8s_master_main.id
}

resource "aws_lb_listener" "k8s_api" {
  depends_on        = [aws_lb_target_group.k8s_api_tg]
  count             = var.k8s_number_of_master_nodes > 1 ? 1 : 0
  load_balancer_arn = aws_lb.k8s_lb[0].arn
  port              = "6443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8s_api_tg[0].arn
  }
}

resource "aws_lb_listener" "k8s_http" {
  depends_on        = [aws_lb_target_group.k8s_http_apps_tg]
  count             = var.k8s_number_of_master_nodes > 1 ? 1 : 0
  load_balancer_arn = aws_lb.k8s_lb[0].arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8s_http_apps_tg[0].arn
  }
}

resource "aws_lb_listener" "k8s_https" {
  depends_on        = [aws_lb_target_group.k8s_https_apps_tg]
  count             = var.k8s_number_of_master_nodes > 1 ? 1 : 0
  load_balancer_arn = aws_lb.k8s_lb[0].arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8s_https_apps_tg[0].arn
  }
}

#########################################################################
# k8s Masters ###########################################################

resource "aws_instance" "k8s_master_main" {
  depends_on             = [aws_security_group.k8s_master_sg, aws_iam_instance_profile.s3_access_profile, aws_lb.k8s_lb]
  ami                    = var.k8s_master_ami_id
  instance_type          = var.k8s_master_instance_type
  subnet_id              = var.k8s_master_subnet_id[0]
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.k8s_master_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.s3_access_profile.name # Attach IAM role to instance

  root_block_device {
    volume_size = var.k8s_master_disk_size
  }

  tags = {
    Name   = "${var.k8s_cluster_name}-master-main"
    Role   = "master"
    Module = "k8s-cluster"
  }

  user_data = templatefile("${path.module}/k8s_master_main_install.tftpl", {
    k8s_cluster_name           = var.k8s_cluster_name,
    load_balancer_dns          = length(aws_lb.k8s_lb) > 0 ? aws_lb.k8s_lb[0].dns_name : "",
    load_balancer_arn          = length(aws_lb.k8s_lb) > 0 ? aws_lb.k8s_lb[0].arn : "",
    k8s_number_of_master_nodes = var.k8s_number_of_master_nodes,
    install_traefik            = var.install_traefik,
    install_argocd             = var.install_argocd,
    install_GPA                = var.install_GPA,
    install_jenkins            = var.install_jenkins,
    install_sonarqube          = var.install_sonarqube,
    install_EFK                = var.install_EFK
  })
}

resource "aws_launch_template" "masters_lt" {
  depends_on    = [aws_instance.k8s_master_main, aws_security_group.k8s_master_sg, aws_lb.k8s_lb]
  count         = var.k8s_number_of_master_nodes > 1 ? 1 : 0
  name          = "${var.k8s_cluster_name}-masters-lt"
  image_id      = var.k8s_master_ami_id
  instance_type = var.k8s_master_instance_type
  key_name      = var.key_name

  block_device_mappings {
    device_name = "/dev/xvda" # The device name for the root volume
    ebs {
      volume_size = var.k8s_master_disk_size
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.s3_access_profile.name # Attach IAM role to instance
  }

  # Use dynamic block to handle security groups since it can be a list
  network_interfaces {
    associate_public_ip_address = true # Associate public IP address

    # Specify the security groups
    security_groups = [aws_security_group.k8s_master_sg.id]
  }

  user_data = base64encode(templatefile("${path.module}/k8s_masters_install.tftpl", {
    k8s_cluster_name = var.k8s_cluster_name,
    k8s_region_code  = var.k8s_region_code
  }))
}

resource "aws_autoscaling_group" "masters_asg" {
  depends_on          = [aws_launch_template.masters_lt]
  count               = var.k8s_number_of_master_nodes > 1 ? 1 : 0
  name                = "${var.k8s_cluster_name}-masters-asg"
  min_size            = var.k8s_number_of_master_nodes == 1 ? 0 : var.k8s_number_of_master_nodes - 1
  max_size            = var.k8s_number_of_master_nodes == 1 ? 0 : var.k8s_number_of_master_nodes - 1
  desired_capacity    = var.k8s_number_of_master_nodes == 1 ? 0 : var.k8s_number_of_master_nodes - 1
  vpc_zone_identifier = [var.k8s_master_subnet_id[0]]
  target_group_arns   = [aws_lb_target_group.k8s_api_tg[0].arn, aws_lb_target_group.k8s_http_apps_tg[0].arn, aws_lb_target_group.k8s_https_apps_tg[0].arn]

  launch_template {
    id      = aws_launch_template.masters_lt[0].id
    version = aws_launch_template.masters_lt[0].latest_version
  }

  tag {
    key                 = "Name"
    value               = "${var.k8s_cluster_name}-master"
    propagate_at_launch = true
  }
  tag {
    key                 = "Role"
    value               = "master"
    propagate_at_launch = true
  }
  tag {
    key                 = "Module"
    value               = "k8s-cluster"
    propagate_at_launch = true
  }
}
#########################################################################
# k8s Workers ###########################################################

resource "aws_launch_template" "worker-lt" {
  depends_on    = [aws_instance.k8s_master_main, aws_security_group.k8s_worker_sg, aws_lb.k8s_lb]
  name          = "${var.k8s_cluster_name}-worker-lt"
  image_id      = var.k8s_worker_ami_id
  instance_type = var.k8s_worker_instance_type
  key_name      = var.key_name

  block_device_mappings {
    device_name = "/dev/xvda" # The device name for the root volume
    ebs {
      volume_size = var.k8s_worker_disk_size
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
    k8s_cluster_name = var.k8s_cluster_name,
    k8s_region_code  = var.k8s_region_code
  }))

}

resource "aws_autoscaling_group" "worker-asg" {
  depends_on          = [aws_launch_template.worker-lt]
  name                = "${var.k8s_cluster_name}-worker-asg"
  min_size            = var.k8s_worker_min_capacity
  max_size            = var.k8s_worker_max_capacity
  desired_capacity    = var.k8s_worker_desired_capacity
  vpc_zone_identifier = [var.k8s_worker_subnet_id[0]]

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
