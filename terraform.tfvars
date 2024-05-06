instance_type  = "t2.medium"
key_name       = ""
ssh_key_path   = ""
ami_id         = "ami-07caf09b362be10b8"

ssh_cidr_blocks = ["0.0.0.0/0"]
http_cidr_blocks = ["0.0.0.0/0"]

# EKS config

cluster_name = "testing"
eks_version = "1.29"
helper_node_ami_id = "ami-07caf09b362be10b8"
helper_instance_type = "t2.micro"
node_group_name = "testing-node-group"
node_group_instance_type = ["t2.small"]
min_size       = 1
max_size       = 2
desired_size   = 2