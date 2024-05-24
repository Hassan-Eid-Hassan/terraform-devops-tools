################################################################################
# General Variables ############################################################

variable "key_name" {
  description = "Key pair name for the EC2 instances"
  type        = string
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks for SSH access"
  type        = list(string)
}

variable "http_cidr_blocks" {
  description = "CIDR blocks for HTTP access"
  type        = list(string)
}

################################################################################
# VPC Variables ################################################################

variable "vpc_name" {
  type        = string
  description = "the name of VPC."
}

variable "igw_name" {
  type        = string
  description = "the name of Internet gateway."
}

variable "router_table_name" {
  type        = string
  description = "the name of Router Table."
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
}

################################################################################
# Jenkins Variables ############################################################

variable "jenkins_ami_id" {
  type        = string
  description = "AMI ID for the Jenkins instance."
}

variable "jenkins_instance_type" {
  type        = string
  description = "Instance type for Jenkins instance."
}

variable "jenkins_linux_distribution" {
  type        = string
  description = "Linux distribution for the Jenkins instance."

  validation {
    condition     = var.jenkins_linux_distribution != "ubuntu" || var.jenkins_linux_distribution != "aws-linux"
    error_message = "The jenkins_linux_distribution value must be 'ubuntu' or 'aws-linux'"
  }
}

################################################################################
# Nexus Variables ##############################################################

variable "nexus_ami_id" {
  type        = string
  description = "AMI ID for the Nexus instance"
}

variable "nexus_instance_type" {
  type        = string
  description = "Instance type for Nexus instance"
  default     = "t2.medium"
}

variable "nexus_linux_distribution" {
  type        = string
  description = "Linux distribution for the Nexus instance."

  validation {
    condition     = var.nexus_linux_distribution != "ubuntu" || var.nexus_linux_distribution != "aws-linux"
    error_message = "The nexus_linux_distribution value must be 'ubuntu' or 'aws-linux'"
  }
}

################################################################################
# EKS Variables ################################################################

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

variable "eks_helper_node_ami_id" {
  description = "AMI ID for the EC2 instances."
  type        = string
}

variable "eks_node_group_ami_id" {
  description = "AMI ID for the EC2 instances."
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

################################################################################
# Kubernetes Variables #########################################################

variable "k8s_master_disk_size" {
  type        = number
  description = "Disk size in GiB for master nodes."
}

variable "k8s_worker_disk_size" {
  type        = number
  description = "Disk size in GiB for worker nodes."
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

################################################################################
################################################################################