resource "aws_instance" "k8s-master" {
  ami           = var.k8s_master_ami_id
  instance_type = var.k8s_master_instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_ids[0] # Assuming master node in the first subnet

  iam_instance_profile = var.iam_instance_profile
  vpc_security_group_ids   = [var.k8s_master_security_group_id]

  tags = {
    Name   = "${var.cluster_name}-master"
    Role   = "master"
    Module = "k8s-cluster"
  }

  # Additional configurations for the master node, such as user data for kubeadm initialization
}

resource "aws_launch_configuration" "worker-lc" {
  name          = "${var.cluster_name}-worker-lc"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile = var.iam_instance_profile
  security_group_ids   = var.security_group_ids

  # Additional configurations for the worker nodes, such as user data for joining the cluster
}

resource "aws_autoscaling_group" "worker-asg" {
  launch_configuration = aws_launch_configuration.worker-lc.id
  min_size             = var.min_capacity
  max_size             = var.max_capacity
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = var.subnet_ids

  tags = [
    {
      key                 = "Name"
      value               = "${var.cluster_name}-worker"
      propagate_at_launch = true
    },
    {
      key                 = "Role"
      value               = "worker"
      propagate_at_launch = true
    },
    {
      key                 = "Module"
      value               = "k8s-cluster"
      propagate_at_launch = true
    },
  ]

  # Additional configurations for the ASG as needed
}