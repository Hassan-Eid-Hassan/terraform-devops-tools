<a href="https://kubernetes.io">
    <img width="500" src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/Kubernetes_logo.svg/2560px-Kubernetes_logo.svg.png" alt="Kubernetes logo"> 
</a>
<p align="center">
    <h1 align="center">Terraform DevOps Tools - Kubernetes Module</h1>
</p>
<h3 align="center">
    <img src="https://img.shields.io/github/license/Hassan-Eid-Hassan/terraform-devops-tools?logoColor=white&label=License&color=F44336" alt="License Badge">
    <img src="https://img.shields.io/github/last-commit/Hassan-Eid-Hassan/terraform-devops-tools?style=flat&logo=git&logoColor=white&color=FFFFFF" alt="Last Commit Badge">
    <img src="https://img.shields.io/github/languages/top/Hassan-Eid-Hassan/terraform-devops-tools?style=flat&color=000000" alt="Top Language Badge">
    <img src="https://img.shields.io/github/languages/count/Hassan-Eid-Hassan/terraform-devops-tools?style=flat&color=000000" alt="Language Count Badge">
</h3>

## Overview

This repository contains Terraform configurations to set up a highly available Kubernetes cluster on AWS. The configuration includes creating necessary AWS resources such as S3 buckets, IAM roles and policies, security groups, load balancers, and EC2 instances for both master and worker nodes. It also provides options to install various Kubernetes tools such as ArgoCD, Grafana-Prometheus-Alertmanager stack, Jenkins, SonarQube, and the Elasticsearch-Filebeat-Kibana stack.

## Architecture
The architecture of the Kubernetes cluster on AWS includes the following components:

<h5 align="center">
    <img width="900" src="https://github.com/Hassan-Eid-Hassan/terraform-devops-tools/blob/kubernetes-module/k8s.svg" alt="Architecture">
</h5>

 - **S3 Bucket:** Used for storing join command for worker and master.
 - **IAM Roles and Policies:** To provide necessary permissions for Kubernetes nodes to access S3.
 - **Security Groups:** To control network traffic to and from the Kubernetes nodes.
 - **Network Load Balancer:** Ensures high availability and distributes traffic across master nodes.
 - **EC2 Main Master Instance:** The frist Master node that will init the Kubernetes cluster.
 - **Autoscaling Groups:** Automatically manage the number of master and worker nodes based on defined policies.

### Single Master Node (k8s_number_of_master_nodes = 1)
If you set k8s_number_of_master_nodes to 1, the cluster will have a single master node. This setup is simpler and more cost-effective but has limited fault tolerance. If the single master node fails, the entire cluster will become unavailable until the master node is restored.

### Multiple Master Nodes (k8s_number_of_master_nodes > 1)
For higher availability and fault tolerance, you can set k8s_number_of_master_nodes to a value greater than 1 (typically 3, 5, or 7). In this configuration:

 - **High Availability:** The cluster remains operational even if one or more master nodes fail.
 - **Load Balancing:** Traffic to the API server is distributed across multiple master nodes, improving performance.
 - **Etcd Cluster:** Multiple master nodes form an etcd cluster, providing data redundancy and consistency.

## Usage

To use this module, include it in your Terraform configuration as shown below. Make sure to specify the `Hassan-Eid-Hassan/tools/devops` terraform registry.

### Example Configuration

```hcl
provider "aws" {
  region = "us-west-2"
}

module "tools" {
  source  = "Hassan-Eid-Hassan/tools/devops"
  version = "2.0.0-kubernetes-aws"
  k8s_cluster_name            = "prod"
  key_name                    = "key_name"
  k8s_sg_vpc_id               = "vpc_id"
  k8s_master_ami_id           = "ami-07caf09b362be10b8"
  k8s_master_subnet_id        = "public_subnet_id"
  k8s_master_instance_type    = "t2.large"
  k8s_master_disk_size        = "100"
  k8s_worker_ami_id           = "ami-07caf09b362be10b8"
  k8s_worker_instance_type    = "t2.xlarge"
  k8s_worker_subnet_id        = "public_subnet_id"
  k8s_worker_min_capacity     = "6"
  k8s_worker_max_capacity     = "8"
  k8s_worker_desired_capacity = "6"
  k8s_worker_disk_size        = "200"
  http_cidr_blocks            = "0.0.0.0/0"
  ssh_cidr_blocks             = "0.0.0.0/0"
  public_subnet_cidrs         = "172.16.4.0/24"
  private_subnet_cidrs        = "172.16.5.0/24"
  k8s_region_code             = "us-west-2"
  k8s_number_of_master_nodes  = "3"
  install_traefik             = "true"
  install_argocd              = "true"
  install_GPA                 = "true"
  install_jenkins             = "false"
  install_sonarqube           = "false"
  install_EFK                 = "true"
}
```

## Input Variables

| Variable Name                    | Type          | Description                                                                                     |
|----------------------------------|---------------|-------------------------------------------------------------------------------------------------|
| install_argocd                   | string        | Whether to install ArgoCD (true/false)                                                          |
| install_GPA                      | string        | Whether to install Grafana-Prometheus-Alertmanager (true/false)                                 |
| install_jenkins                  | string        | Whether to install Jenkins (true/false)                                                         |
| install_sonarqube                | string        | Whether to install SonarQube (true/false)                                                       |
| install_EFK                      | string        | Whether to install Elasticsearch-Filebeat-Kibana (true/false)                                   |
| install_traefik                  | string        | Whether to install Traefik [Installed by default if number of masters more than 1] (true/false) |
| k8s_region_code                  | string        | The region code of the Kubernetes cluster                                                       |
| k8s_number_of_master_nodes       | number        | Number of Kubernetes masters nodes                                                              |
| k8s_master_ami_id                | string        | AMI ID for the Kubernetes master node                                                           |
| k8s_worker_ami_id                | string        | AMI ID for the Kubernetes worker nodes                                                          |
| k8s_master_instance_type         | string        | Instance type for the Kubernetes master node                                                    |
| k8s_worker_instance_type         | string        | Instance type for the Kubernetes worker nodes                                                   |
| key_name                         | string        | Key name for SSH access                                                                         |
| k8s_master_subnet_id             | list(string)  | Subnet IDs for the masters node                                                                 |
| k8s_worker_subnet_id             | list(string)  | Subnet IDs for the workers nodes                                                                |
| k8s_cluster_name                 | string        | Name for the Kubernetes cluster                                                                 |
| k8s_worker_min_capacity          | number        | Minimum size for the worker auto-scaling group                                                  |
| k8s_worker_max_capacity          | number        | Maximum size for the worker auto-scaling group                                                  |
| k8s_worker_desired_capacity      | number        | Desired size for the worker auto-scaling group                                                  |
| k8s_sg_vpc_id                    | string        | VPC ID for the Kubernetes Cluster Security groups                                               |
| ssh_cidr_blocks                  | list(string)  | CIDR blocks for SSH access                                                                      |
| http_cidr_blocks                 | list(string)  | CIDR blocks for HTTP access                                                                     |
| public_subnet_cidrs              | list(string)  | Public Subnet CIDR values                                                                       |
| private_subnet_cidrs             | list(string)  | Private Subnet CIDR values                                                                      |
| k8s_worker_disk_size             | number        | Disk size in GiB for worker nodes                                                               |
| k8s_master_disk_size             | number        | Disk size in GiB for master nodes                                                               |

## Outputs

| Output Name           | Description                                     |
|-----------------------|-------------------------------------------------|
| k8s_master_public_ip  | Public IP address of the Kubernetes master node |

## Prerequisites

- An AWS account with sufficient permissions to create EC2 instances.
- Terraform installed on your local machine.

## Getting Started

1. Initialize Terraform:

Initialize the Terraform configuration.

```sh
terraform init
```

2. Plan the Deployment:

Create an execution plan to review the actions Terraform will take.

```sh
terraform plan
```

3. Apply the Deployment:

Apply the configuration to deploy the Nexus server.

```sh
terraform apply
```

4. Destroy the Deployment:

To destroy the deployed resources when they are no longer needed.

```sh
terraform destroy
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with improvements or bug fixes.

### How to Contribute

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -am 'Add new feature'`).
5. Push to the branch (`git push origin feature-branch`).
6. Create a new Pull Request.

## License

This repository is licensed under the MIT License. See the LICENSE file for more details.

## Contact

For questions, issues, or suggestions, please open an issue in this repository.
