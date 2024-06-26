################################################################################
# General Values ###############################################################

key_name         = ""
ssh_cidr_blocks  = ["0.0.0.0/0"]
http_cidr_blocks = ["0.0.0.0/0"]

################################################################################
# VPC Values ###################################################################

vpc_name             = "devopsToolsVpc"
igw_name             = "devopsToolsIgw"
router_table_name    = "devopsToolsRouterTable"
vpc_cidr_block       = "172.16.0.0/16"
public_subnet_cidrs  = ["172.16.1.0/24", "172.16.2.0/24"]
private_subnet_cidrs = ["172.16.3.0/24", "172.16.4.0/24"]
azs                  = ["us-east-1a", "us-east-1b"]

################################################################################
# Jenkins Values ###############################################################

jenkins_instance_type   = "t2.medium"
jenkins_ami_id          = "ami-04b70fa74e45c3917"
jenkins_linux_distribution = "ubuntu"

################################################################################
# Nexus Values #################################################################

nexus_instance_type   = "t2.medium"
nexus_ami_id          = "ami-04b70fa74e45c3917"
nexus_linux_distribution = "ubuntu"

################################################################################
# EKS Values ###################################################################

eks_region_code                = "us-east-1"
eks_cluster_name               = "testing-eks"
eks_cluster_version            = "1.29"
eks_helper_node_ami_id         = "ami-07caf09b362be10b8"
eks_helper_instance_type       = "t2.medium"
eks_node_group_instance_type   = ["t2.medium"]
eks_node_group_min_size        = 1
eks_node_group_max_size        = 2
eks_node_group_desired_size    = 2
eks_node_group_max_unavailable = 1
eks_node_group_ami_id          = "ami-07caf09b362be10b8"
eks_node_group_disk_size       = 30
eks_node_group_capacity_type   = "ON_DEMAND"

################################################################################
# Kubernetes Variables #########################################################

k8s_region_code          = "us-east-1"
k8s_cluster_name         = "testing-k8s"
k8s_master_ami_id        = "ami-07caf09b362be10b8"
k8s_master_instance_type = "t2.medium"
k8s_number_of_master_nodes  = 1
k8s_master_disk_size = 30

k8s_worker_ami_id           = "ami-07caf09b362be10b8"
k8s_worker_instance_type    = "t2.large"
k8s_worker_min_capacity     = 2
k8s_worker_max_capacity     = 2
k8s_worker_desired_capacity = 2
k8s_worker_disk_size        = 50

install_traefik   = "true"
install_argocd    = "true"
install_GPA       = "false"
install_jenkins   = "false"
install_sonarqube = "false"
install_EFK       = "false"

################################################################################
################################################################################