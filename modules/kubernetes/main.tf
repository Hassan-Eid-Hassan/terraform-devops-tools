resource "aws_instance" "k8s-master" {
    ami           = var.k8s_master_ami_id
    instance_type = var.k8s_master_instance_type
    subnet_id     = var.k8s_master_subnet_id
    key_name      = var.key_name
    vpc_security_group_ids = [var.k8s_master_security_group_id]

    tags = {
        Name = "k8s-master"
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
  program = ["sh", "-c", "ssh -i ${var.ssh_key_path} ${var.k8s_master_instance_user}@${aws_instance.master.public_ip} 'cat /tmp/join_command.txt'"]
}