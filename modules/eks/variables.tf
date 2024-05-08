variable "cluster_name" {
    type = string
    description = "The name of the EKS cluster."
}

variable "eks_version" {
    description = "The EKS Cluster Kubernetes version."
    type        = string
}

variable "subnet_ids" {
    type = list(string)
    description = "List of subnet IDs for the EKS cluster and node group."
}

variable "helper_node_ami_id" {
    description = "AMI ID for the EC2 instances."
    type        = string
}

variable "node_group_ami_id" {
    description = "AMI ID for the EC2 instances."
    type        = string
}

variable "key_name" {
    description = "Key pair name for the EC2 instances."
    type        = string
}

variable "helper_instance_type" {
    description = "Instance type for the EC2 instances."
    type        = string
}

variable "node_group_name" {
    type = string
    description = "The name of node group."
}

variable "node_group_instance_type" {
    description = "Instance type for the EC2 instances."
    type        = list(string)
}

variable "min_size" {
    type = number
    description = "Minimum number of nodes in the node group, default are 2."
    default = 2
}

variable "max_size" {
    type = number
    description = "Maximum number of nodes in the node group, default are 2."
    default = 2
}

variable "desired_size" {
    type = number
    description = "Desired number of nodes in the node group, default are 2."
    default = 2
}

variable "security_group_id" {
    type = string
    description = "Security group ID for helper-node instance."
}

variable "disk_size" {
    type = string
    description = "Disk size in GiB for worker nodes."
}

variable "capacity_type" {
    type = string
    description = "Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT."

    validation {
        condition = can(jsondecode(["ON_DEMAND", "SPOT"]), var.capacity_type)
        error_message = "capacity_type must be either 'ON_DEMAND' or 'SPOT'."
    }
}

variable "eks_node_group_template_name" {
    type = string
    description = "The name of eks node group template."
}

variable "eks_helper_node_name" {
    type = string
    description = "EKS helper node name."
}