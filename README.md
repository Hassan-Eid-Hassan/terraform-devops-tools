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

This repository contains a Terraform module to deploy a Kubernetes cluster on AWS. The module is located in the `kubernetes-module` branch and provides an easy way to set up and manage Kubernetes clusters.

## Features

- **Automated Deployment:** Easily deploy a Kubernetes cluster on AWS EC2 instances.
- **Configurable:** Customize instance types, worekr node count, and other parameters.
- **Outputs:** Provides useful outputs such as Master Node IP.
- **Worker Node Automation:** Automatically joins worker nodes to the Kubernetes cluster using kubeadm.

## Usage

To use this module, include it in your Terraform configuration as shown below. Make sure to specify the `kubernetes-module` branch.

### Example Configuration

```hcl
provider "aws" {
  region = "us-west-2"
}

module "tools" {
  source  = "Hassan-Eid-Hassan/tools/devops"
  version = "1.0.0-kubernetes-aws"
  k8s_cluster_name            = "k8s_cluster_name"
  key_name                    = "key_name"
  k8s_sg_vpc_id               = "vpc_id"
  k8s_master_ami_id           = "k8s_master_ami_id"
  k8s_master_subnet_id        = "subnet_id"
  k8s_master_instance_type    = "k8s_master_instance_type"
  k8s_worker_ami_id           = "k8s_worker_ami_id"
  k8s_worker_instance_type    = "k8s_worker_instance_type"
  k8s_worker_subnet_id        = "subnet_id"
  k8s_worker_min_capacity     = "k8s_worker_min_capacity"
  k8s_worker_max_capacity     = "k8s_worker_max_capacity"
  k8s_worker_desired_capacity = "k8s_worker_desired_capacity"
  http_cidr_blocks            = "http_cidr_blocks"
  ssh_cidr_blocks             = "ssh_cidr_blocks"
  public_subnet_cidrs         = "public_subnet_cidrs"
  private_subnet_cidrs        = "private_subnet_cidrs"
}
```

## Input Variables

| Variable Name                 | Type          | Description                                        |
|-------------------------------|---------------|----------------------------------------------------|
| k8s_master_ami_id             | string        | AMI ID for the Kubernetes master node              |
| k8s_worker_ami_id             | string        | AMI ID for the Kubernetes worker nodes             |
| k8s_master_instance_type      | string        | Instance type for the Kubernetes master node       |
| k8s_worker_instance_type      | string        | Instance type for the Kubernetes worker nodes      |
| key_name                      | string        | Key name for SSH access                            |
| k8s_master_subnet_id          | string        | Subnet ID for the master node                      |
| k8s_worker_subnet_id          | string        | Subnet IDs for the worker nodes                    |
| k8s_cluster_name              | string        | Name for the Kubernetes cluster                    |
| k8s_worker_min_capacity       | number        | Minimum size for the worker auto-scaling group     |
| k8s_worker_max_capacity       | number        | Maximum size for the worker auto-scaling group     |
| k8s_worker_desired_capacity   | number        | Desired size for the worker auto-scaling group     |
| k8s_sg_vpc_id                 | string        | VPC ID for the Kubernetes Cluster Security groups  |
| ssh_cidr_blocks               | list(string)  | CIDR blocks for SSH access                         |
| http_cidr_blocks              | list(string)  | CIDR blocks for HTTP access                        |
| public_subnet_cidrs           | list(string)  | Public Subnet CIDR values                          |
| private_subnet_cidrs          | list(string)  | Private Subnet CIDR values                         |

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