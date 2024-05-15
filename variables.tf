variable "jenkins_ami_id" {
  type        = string
  description = "AMI ID for the Jenkins instance."
}

variable "jenkins_instance_type" {
  type        = string
  description = "Instance type for Jenkins instance."
}

variable "key_name" {
  type        = string
  description = "Key name for SSH access to the Jenkins instance."
}

variable "jenkins_subnet_id" {
  type        = string
  description = "ID of the subnet for the Jenkins instance."
}

variable "jenkins_sg_vpc_id" {
  type        = string
  description = "VPC ID for the Jenkins Security group"
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks for SSH access"
  type        = list(string)
}

variable "http_cidr_blocks" {
  description = "CIDR blocks for HTTP access"
  type        = list(string)
}
