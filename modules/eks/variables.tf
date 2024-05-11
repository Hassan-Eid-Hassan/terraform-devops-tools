variable "eks_region_code" {
  type        = string
  description = "The region code of the EKS cluster."
}

variable "eks_cluster_name" {
  type        = string
  description = "The name of the EKS cluster."
}

variable "eks_cluster_version" {
  description = "The EKS Cluster Kubernetes version."
  type        = string
}

variable "eks_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the EKS cluster and node group."
}

variable "eks_helper_node_ami_id" {
  description = "AMI ID for the EC2 instances."
  type        = string
}

variable "eks_node_group_ami_id" {
  description = "AMI ID for the EC2 instances."
  type        = string
}

variable "key_name" {
  description = "Key pair name for the EC2 instances."
  type        = string
}

variable "eks_helper_instance_type" {
  description = "Instance type for the EC2 instances."
  type        = string
}

variable "eks_node_group_instance_type" {
  description = "Instance type for the EC2 instances."
  type        = list(string)
}

variable "eks_node_group_min_size" {
  type        = number
  description = "Minimum number of nodes in the node group."
}

variable "eks_node_group_max_size" {
  type        = number
  description = "Maximum number of nodes in the node group."
}

variable "eks_node_group_desired_size" {
  type        = number
  description = "Desired number of nodes in the node group."
}

variable "eks_node_group_max_unavailable" {
  type        = number
  description = "Maximum number of nodes to be unavailable at update time."
}

variable "eks_node_group_disk_size" {
  type        = number
  description = "Disk size in GiB for worker nodes."
}

variable "eks_node_group_capacity_type" {
  type        = string
  description = "Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT."
}

variable "eks_sg_vpc_id" {
  type        = string
  description = "VPC ID for the EKS Cluster Security groups"
}
