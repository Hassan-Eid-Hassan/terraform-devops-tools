resource "aws_instance" "k8s_master" {
    ami           = var.k8s_master_ami_id
    instance_type = var.k8s_master_instance_type
    subnet_id     = var.k8s_master_subnet_id
    key_name      = var.key_name
    vpc_security_group_ids = [var.k8s_master_security_group_id]

    tags = {
        Name   = "${var.k8s_cluster_name}-master"
        Role   = "master"
        Module = "k8s-cluster"
    }

    connection {
        type        = "ssh"
        user        = var.k8s_master_instance_user
        private_key = file(var.ssh_key_path)
        host        = aws_instance.k8s_master.public_ip
    }

    # Provision k8s_master installation script
    provisioner "file" {
        source      = "${path.module}/k8s_master_install.sh"
        destination = "/tmp/k8s_master_install.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo sed -i 's/\r$//' /tmp/k8s_master_install.sh",
            "sudo bash /tmp/k8s_master_install.sh"
        ]
    }
}

# Read the join command from the master node
data "external" "join_command" {
    program = ["sh", "-c", "ssh -i ${var.ssh_key_path} ${var.k8s_master_instance_user}@${aws_instance.k8s_master.public_ip} 'cat /tmp/join_command.txt'"]
}

resource "aws_launch_configuration" "worker-lc" {
    name          = "${var.k8s_cluster_name}-worker-lc"
    image_id      = var.k8s_worker_ami_id
    instance_type = var.k8s_worker_instance_type
    key_name      = var.key_name
    security_groups = var.k8s_worker_security_group_id
    
    connection {
        type        = "ssh"
        user        = var.k8s_worker_instance_user
        private_key = file(var.ssh_key_path)
        host        = aws_autoscaling_group.worker-asg.instances[count.index].public_dns
    }

    # Provision k8s_worker installation script
    provisioner "file" {
        source      = "${path.module}/k8s_worker_install.sh"
        destination = "/tmp/k8s_worker_install.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo sed -i 's/\r$//' /tmp/k8s_worker_install.sh",
            "sudo bash /tmp/k8s_worker_install.sh",
            "${data.external.join_command.result.output}"
        ]
    }
}

resource "aws_autoscaling_group" "worker-asg" {
  launch_configuration = aws_launch_configuration.worker-lc.id
  min_size             = var.k8s_worker_min_capacity
  max_size             = var.k8s_worker_max_capacity
  desired_capacity     = var.k8s_worker_desired_capacity
  vpc_zone_identifier  = var.k8s_worker_subnet_id

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