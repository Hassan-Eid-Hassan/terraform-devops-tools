# General Variables

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
}

variable "http_cidr_blocks" {
    description = "CIDR blocks for HTTP access"
    type        = list(string)
}

# VPC Variables
variable "vpc_name" {
    type = string
    description = "the name of VPC."
}

variable "igw_name" {
    type = string
    description = "the name of Internet gateway."
}

variable "router_table_name" {
    type = string
    description = "the name of Router Table."
}

variable "vpc_cidr_block" {
    type = string
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

# jenkins Variables

variable "jenkins_ami_id" {
    type        = string
    description = "AMI ID for the Jenkins instance."
}

variable "jenkins_instance_type" {
    type = string
    description = "Instance type for Jenkins instance."
}


variable "jenkins_subnet_id" {
    type = string
    description = "ID of the subnet for the Jenkins instance."
}

variable "jenkins_vpc_id" {
    type = string
    description = "VPC ID for the Jenkins instance"
}

variable "jenkins_security_group_id" {
    type = string
    description = "Security group ID for Jenkins instance."
}

variable "jenkins_instance_user" {
    type = string
    description = "The user in the instance to ssh using it."
}

# Nexus Variables

variable "nexus_ami_id" {
    type        = string
    description = "AMI ID for the Nexus instance"
}

variable "nexus_instance_type" {
    type = string
    description = "Instance type for Nexus instance"
    default = "t2.medium"
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

variable "nexus_instance_user" {
    type = string
    description = "The user in the instance to ssh using it."
}

# EKS Variables

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

variable "node_group_instance_name" {
    type = string
    description = "The name of node group instance."
}

variable "eks_node_group_template_name" {
    type = string
    description = "The name of eks node group template."
}

variable "eks_helper_node_name" {
    type = string
    description = "EKS helper node name."
}

# Kubernetes Variables

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
