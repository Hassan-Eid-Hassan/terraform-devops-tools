variable "instance_type" {
    description = "Instance type for the EC2 instances"
    type        = string
    default     = "t2.medium"
}

variable "ami_id" {
    description = "AMI ID for the EC2 instances"
    type        = string
    default     = "ami-04b70fa74e45c3917"
}

variable "key_name" {
    description = "Key pair name for the EC2 instances"
    type        = string
}

variable "ssh_key_path" {
    type = string
    description = "Path to your private SSH key file"
}

variable "ssh_cidr_blocks" {
    description = "CIDR blocks for SSH access"
    type        = list(string)
    default     = ["0.0.0.0/0"]
}

variable "http_cidr_blocks" {
    description = "CIDR blocks for HTTP access"
    type        = list(string)
    default     = ["0.0.0.0/0"]
}

# EKS config
variable "cluster_name" {
    type = string
    description = "The name of the EKS cluster."
}

variable "eks_version" {
    description = "Key pair name for the EC2 instances"
    type        = string
}

variable "helper_node_ami_id" {
    description = "AMI ID for the EC2 instances"
    type        = string
    default     = "ami-04b70fa74e45c3917"
}

variable "helper_instance_type" {
    description = "Instance type for the EC2 instances"
    type        = string
    default     = "t2.micro"
}

variable "node_group_name" {
    type = string
    description = "The name of the node group."
}

variable "node_group_instance_type" {
    description = "Instance type for the EC2 instances"
    type        = list(string)
    default     = ["t2.small"]
}

variable "min_size" {
    type = number
    description = "Minimum number of nodes in the node group."
    default = 2
}

variable "max_size" {
    type = number
    description = "Maximum number of nodes in the node group."
    default = 2
}

variable "desired_size" {
    type = number
    description = "Desired number of nodes in the node group."
    default = 2
}