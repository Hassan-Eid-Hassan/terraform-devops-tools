variable "install_argocd" {
  description = "Whether to install ArgoCD"
  type        = string
  validation {
    condition     = contains(["true", "false"], var.install_argocd)
    error_message = "install_argocd must be 'true' or 'false'."
  }
}

variable "install_GPA" {
  description = "Whether to install Grafana-Prometheus-Alertmanager"
  type        = string
  validation {
    condition     = contains(["true", "false"], var.install_GPA)
    error_message = "install_GPA must be 'true' or 'false'."
  }
}

variable "install_jenkins" {
  description = "Whether to install Jenkins"
  type        = string
  validation {
    condition     = contains(["true", "false"], var.install_jenkins)
    error_message = "install_jenkins must be 'true' or 'false'."
  }
}

variable "install_sonarqube" {
  description = "Whether to install SonarQube"
  type        = string
  validation {
    condition     = contains(["true", "false"], var.install_sonarqube)
    error_message = "install_sonarqube must be 'true' or 'false'."
  }
}

variable "install_EFK" {
  description = "Whether to install Elasticsearch-Filebeat-Kibana"
  type        = string
  validation {
    condition     = contains(["true", "false"], var.install_EFK)
    error_message = "install_EFK must be 'true' or 'false'."
  }
}

variable "install_traefik" {
  description = "Whether to install Traefik [Installed by default if number of masters more than 1]"
  type        = string
  validation {
    condition     = contains(["true", "false"], var.install_traefik)
    error_message = "install_traefik must be 'true' or 'false'."
  }
}

variable "k8s_region_code" {
  type        = string
  description = "The region code of the Kubernetes cluster."
}

variable "k8s_number_of_master_nodes" {
  description = "Number of Kubernetes masters nodes."
  type        = number

  validation {
    condition     = var.k8s_number_of_master_nodes != 1 || var.k8s_number_of_master_nodes != 3 || var.k8s_number_of_master_nodes != 5 || var.k8s_number_of_master_nodes != 7
    error_message = "The k8s_number_of_master_nodes value must be in [1, 3, 5, 7]"
  }
}

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
  description = "Subnet IDs for the masters node."
  type        = list(string)
}

variable "k8s_worker_subnet_id" {
  description = "Subnet IDs for the workers nodes."
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

variable "k8s_worker_disk_size" {
  type        = number
  description = "Disk size in GiB for worker nodes."
}

variable "k8s_master_disk_size" {
  type        = number
  description = "Disk size in GiB for master nodes."
}
