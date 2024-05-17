variable "nexus_linux_distribution" {
  type        = string
  description = "Linux distribution for the Nexus instance."
  
  validation {
    condition = var.nexus_linux_distribution != "ubuntu" || "aws-linux"
    error_message = "The nexus_linux_distribution value must be 'ubuntu' or 'aws-linux'"
  }
}

variable "nexus_ami_id" {
  type        = string
  description = "AMI ID for the Nexus instance"
}

variable "nexus_instance_type" {
  type        = string
  description = "Instance type for Nexus instance"
}

variable "key_name" {
  type        = string
  description = "Key name for SSH access to the Nexus instance"
}

variable "nexus_subnet_id" {
  type        = string
  description = "ID of the subnet for the Nexus instance"
}

variable "nexus_sg_vpc_id" {
  type        = string
  description = "VPC ID for the Nexus Security group"
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks for SSH access"
  type        = list(string)
}

variable "http_cidr_blocks" {
  description = "CIDR blocks for HTTP access"
  type        = list(string)
}
