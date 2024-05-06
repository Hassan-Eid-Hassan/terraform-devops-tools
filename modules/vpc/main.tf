# Main Terraform file in the VPC module (modules/vpc/main.tf)

# Data source for available availability zones in the region
data "aws_availability_zones" "available" {
    state = "available"
}

# VPC resource
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = {
        Name = var.vpc_name
    }
}

# Public subnet
resource "aws_subnet" "public_subnet" {
    count             = length(var.public_subnet_cidrs)
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = element(var.public_subnet_cidrs, count.index)
    availability_zone = element(var.azs, count.index)
    map_public_ip_on_launch = true
    tags = {
        Name = "Public Subnet ${count.index + 1}"
    }
}

resource "aws_subnet" "private_subnet" {
    count             = length(var.private_subnet_cidrs)
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = element(var.private_subnet_cidrs, count.index)
    availability_zone = element(var.azs, count.index)

    tags = {
    Name = "Private Subnet ${count.index + 1}"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = var.igw_name
    }
}

# Route Table
resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "2nd Route Table"
    }
}

# Route Table Association
resource "aws_route_table_association" "rta" {
    count          = length(var.public_subnet_cidrs)
    subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
    route_table_id = aws_route_table.route_table.id
}