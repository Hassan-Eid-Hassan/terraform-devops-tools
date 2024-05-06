resource "aws_instance" "jenkins" {
    ami           = var.ami_id
    instance_type = var.instance_type
    subnet_id     = var.subnet_id
    key_name      = var.key_name
    vpc_security_group_ids = [var.security_group_id]

    tags = {
        Name = "Jenkins"
    }

    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file(var.ssh_key_path)
        host        = aws_instance.jenkins.public_ip
    }

    # Provision Jenkins installation script
    provisioner "file" {
        source      = "${path.module}/jenkins_install.sh"
        destination = "/tmp/jenkins_install.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo sed -i 's/\r$//' /tmp/jenkins_install.sh",
            "sudo bash /tmp/jenkins_install.sh"
        ]
    }
}
