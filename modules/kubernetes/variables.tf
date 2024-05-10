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

variable "ssh_key_path" {
    description = "Path to the SSH private key file."
    type        = string
}

variable "k8s_master_instance_user" {
    description = "SSH username for accessing the master node."
    type        = string
}

variable "k8s_worker_instance_user" {
    description = "SSH username for accessing the worker nodes."
    type        = string
}

variable "k8s_master_subnet_id" {
    description = "Subnet ID for the master node."
    type        = string
}

variable "k8s_worker_subnet_id" {
    description = "Subnet IDs for the worker nodes."
    type        = list(string)
}

variable "k8s_master_security_group_id" {
    description = "Security group ID for the master node."
    type        = string
}

variable "k8s_worker_security_group_id" {
    description = "Security group ID for the worker nodes."
    type        = list(string)
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
