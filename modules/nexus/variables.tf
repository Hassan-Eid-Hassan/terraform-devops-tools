variable "nexus_ami_id" {
    type        = string
    description = "AMI ID for the Nexus instance"
}

variable "nexus_instance_type" {
    type = string
    description = "Instance type for Nexus instance"
    default = "t2.medium"
}

variable "key_name" {
    type = string
    description = "Key name for SSH access to the Nexus instance"
}

variable "nexus_subnet_id" {
    type = string
    description = "ID of the subnet for the Nexus instance"
}

variable "nexus_vpc_id" {
    type = string
    description = "VPC ID for the Nexus instance"
}

variable "nexus_security_group_id" {
    type = string
    description = "Security group ID for Nexus instance"
}

variable "ssh_key_path" {
    type = string
    description = "Path to your private SSH key file"
}

variable "nexus_instance_user" {
    type = string
    description = "The user in the instance to ssh using it."
}