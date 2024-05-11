variable "k8s_master_ami_id" {
  description = "AMI ID for the Kubernetes master node."
  type        = string
}

variable "k8s_worker_ami_id" {
  description = "AMI ID for the Kubernetes worker nodes."
  type        = string
}

variable "k8s_master_instance_type" {
  description = "Instance type for the Kubernetes master node."
  type        = string
}

variable "k8s_worker_instance_type" {
  description = "Instance type for the Kubernetes worker nodes."
  type        = string
}

variable "key_name" {
  description = "Key name for SSH access."
  type        = string
}

variable "k8s_master_subnet_id" {
  description = "Subnet ID for the master node."
  type        = string
}

variable "k8s_worker_subnet_id" {
  description = "Subnet IDs for the worker nodes."
  type        = string
}

variable "k8s_cluster_name" {
  description = "Name for the Kubernetes cluster."
  type        = string
}

variable "k8s_worker_min_capacity" {
  description = "Minimum size for the worker auto-scaling group."
  type        = number
}

variable "k8s_worker_max_capacity" {
  description = "Maximum size for the worker auto-scaling group."
  type        = number
}

variable "k8s_worker_desired_capacity" {
  description = "Desired size for the worker auto-scaling group."
  type        = number
}

variable "k8s_sg_vpc_id" {
  type        = string
  description = "VPC ID for the Kubernetes Cluster Security groups"
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks for SSH access"
  type        = list(string)
}

variable "http_cidr_blocks" {
  description = "CIDR blocks for HTTP access"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}
