# VPC module
module "vpc" {
  source               = "./modules/vpc"
  vpc_name             = var.vpc_name
  igw_name             = var.igw_name
  router_table_name    = var.router_table_name
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs

}

# Jenkins module
module "jenkins" {
  source                = "./modules/jenkins"
  depends_on            = [module.vpc]
  jenkins_instance_type = var.jenkins_instance_type
  jenkins_ami_id        = var.jenkins_ami_id
  key_name              = var.key_name
  jenkins_subnet_id     = module.vpc.public_subnet_id[0]
  jenkins_sg_vpc_id     = module.vpc.vpc_id
  http_cidr_blocks      = var.http_cidr_blocks
  ssh_cidr_blocks       = var.ssh_cidr_blocks
}

# Nexus module
module "nexus" {
  source              = "./modules/nexus"
  depends_on          = [module.vpc]
  nexus_instance_type = var.nexus_instance_type
  nexus_ami_id        = var.nexus_ami_id
  key_name            = var.key_name
  nexus_subnet_id     = module.vpc.public_subnet_id[0]
  nexus_sg_vpc_id     = module.vpc.vpc_id
  http_cidr_blocks    = var.http_cidr_blocks
  ssh_cidr_blocks     = var.ssh_cidr_blocks
}

# Kubernetes module
module "Kubernetes" {
  source                      = "./modules/kubernetes"
  depends_on                  = [module.vpc]
  k8s_cluster_name            = var.k8s_cluster_name
  key_name                    = var.key_name
  k8s_sg_vpc_id               = module.vpc.vpc_id
  k8s_master_ami_id           = var.k8s_master_ami_id
  k8s_master_subnet_id        = module.vpc.public_subnet_id[0]
  k8s_master_instance_type    = var.k8s_master_instance_type
  k8s_worker_ami_id           = var.k8s_worker_ami_id
  k8s_worker_instance_type    = var.k8s_worker_instance_type
  k8s_worker_subnet_id        = module.vpc.public_subnet_id[0]
  k8s_worker_min_capacity     = var.k8s_worker_min_capacity
  k8s_worker_max_capacity     = var.k8s_worker_max_capacity
  k8s_worker_desired_capacity = var.k8s_worker_desired_capacity
  http_cidr_blocks            = var.http_cidr_blocks
  ssh_cidr_blocks             = var.ssh_cidr_blocks
  public_subnet_cidrs         = var.public_subnet_cidrs
  private_subnet_cidrs        = var.private_subnet_cidrs
}

# EKS module
module "eks" {
  source                         = "./modules/eks"
  depends_on                     = [module.vpc]
  key_name                       = var.key_name
  eks_sg_vpc_id                  = module.vpc.vpc_id
  eks_cluster_name               = var.eks_cluster_name
  eks_cluster_version            = var.eks_cluster_version
  eks_subnet_ids                 = module.vpc.public_subnet_id
  eks_helper_node_ami_id         = var.eks_helper_node_ami_id
  eks_helper_instance_type       = var.eks_helper_instance_type
  eks_node_group_instance_type   = var.eks_node_group_instance_type
  eks_node_group_min_size        = var.eks_node_group_min_size
  eks_node_group_max_size        = var.eks_node_group_max_size
  eks_node_group_desired_size    = var.eks_node_group_desired_size
  eks_node_group_max_unavailable = var.eks_node_group_max_unavailable
  eks_node_group_ami_id          = var.eks_node_group_ami_id
  eks_node_group_disk_size       = var.eks_node_group_disk_size
  eks_node_group_capacity_type   = var.eks_node_group_capacity_type
  eks_region_code                = var.eks_region_code
}
