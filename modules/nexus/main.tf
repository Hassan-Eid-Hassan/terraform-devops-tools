resource "aws_instance" "nexus" {
    ami           = var.ami_id
    instance_type = var.instance_type
    subnet_id     = var.subnet_id
    key_name      = var.key_name
    vpc_security_group_ids = [var.security_group_id]

    tags = {
        Name = "Nexus"
    }

    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file(var.ssh_key_path)
        host        = aws_instance.nexus.public_ip
    }

    # Provision Nexus installation script
    provisioner "file" {
        source      = "${path.module}/nexus_install.sh"
        destination = "/tmp/nexus_install.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo sed -i 's/\r$//' /tmp/nexus_install.sh",
            "sudo bash /tmp/nexus_install.sh"
        ]
    }
}
