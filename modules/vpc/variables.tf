variable "vpc_name" {
    type = string
    description = "the name of VPC."
    default = "devopsToolsVpc"
}

variable "igw_name" {
    type = string
    description = "the name of Internet gateway."
    default = "devopsToolsIgw"
}

variable "router_table_name" {
    type = string
    description = "the name of Router Table."
    default = "devopsToolsRouterTable"
}

variable "vpc_cidr_block" {
    type = string
    description = "CIDR block for the VPC."
    default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["us-east-1a", "us-east-1b"]
}