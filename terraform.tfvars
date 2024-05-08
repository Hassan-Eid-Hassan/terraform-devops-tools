# General Values

key_name       = ""
ssh_key_path   = ""
ssh_cidr_blocks = ["0.0.0.0/0"]
http_cidr_blocks = ["0.0.0.0/0"]

# VPC Values
vpc_name = "devopsToolsVpc"
igw_name = "devopsToolsIgw"
router_table_name = "devopsToolsRouterTable"
vpc_cidr_block = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
azs = ["us-east-1a", "us-east-1b"]

# Jenkins Values

jenkins_instance_type   = "t2.medium"
jenkins_ami_id          = "ami-07caf09b362be10b8"
jenkins_instance_user = "ec2-user"

# Nexus Values

nexus_instance_type   = "t2.medium"
nexus_ami_id          = "ami-07caf09b362be10b8"
nexus_instance_user = "ec2-user"

# EKS Values

cluster_name = "testing"
eks_helper_node_name = "testing-helper-node"
eks_node_group_template_name = "testing-node-group-template"
node_group_name = "testing-node-group"
eks_version = "1.29"
helper_node_ami_id = "ami-07caf09b362be10b8"
helper_instance_type = "t2.micro"
node_group_instance_type = ["t2.small"]
node_group_ami_id = "ami-07caf09b362be10b8"
min_size       = 1
max_size       = 2
desired_size   = 2
disk_size = "50"
capacity_type = "ON_DEMAND"
