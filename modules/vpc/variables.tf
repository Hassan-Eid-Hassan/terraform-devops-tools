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