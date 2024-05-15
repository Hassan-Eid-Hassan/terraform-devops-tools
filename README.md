<a href="https://www.sonatype.com/products/sonatype-nexus-repository">
    <img align="center" width="780" src="https://repository.ow2.org/nexus/images/NexusRepoMngr_withSonatype@3x.png" alt="Nexus logo"> 
</a>
<p align="center">
    <h1 align="center">Terraform DevOps Tools - Nexus Module</h1>
</p>
<h3 align="center">
    <img src="https://img.shields.io/github/license/Hassan-Eid-Hassan/terraform-devops-tools?logoColor=white&label=License&color=F44336" alt="License Badge">
    <img src="https://img.shields.io/github/last-commit/Hassan-Eid-Hassan/terraform-devops-tools?style=flat&logo=git&logoColor=white&color=FFFFFF" alt="Last Commit Badge">
    <img src="https://img.shields.io/github/languages/top/Hassan-Eid-Hassan/terraform-devops-tools?style=flat&color=000000" alt="Top Language Badge">
    <img src="https://img.shields.io/github/languages/count/Hassan-Eid-Hassan/terraform-devops-tools?style=flat&color=000000" alt="Language Count Badge">
</h3>

## Overview

This repository contains a Terraform module to deploy a Nexus server on AWS. The module is located in the `nexus-module` branch and provides an easy way to set up and manage Nexus instances.

## Features

- **Automated Deployment:** Easily deploy Nexus on AWS EC2 instances.
- **Configurable:** Customize instance type, AMI, and other parameters.
- **Outputs:** Provides useful outputs such as public IP.

## Usage

To use this module, include it in your Terraform configuration as shown below. Make sure to specify the `nexus-module` branch.

### Example Configuration

```hcl
provider "aws" {
  region = "us-west-2"
}

module "nexus" {
  source  = "Hassan-Eid-Hassan/tools/devops"
  version = "1.0.0-nexus-aws"
  nexus_instance_type = "nexus_instance_type"
  nexus_ami_id        = "nexus_ami_id"
  key_name            = "key_name"
  nexus_subnet_id     = "subnet_id"
  nexus_sg_vpc_id     = "vpc_id"
  http_cidr_blocks    = "http_cidr_blocks"
  ssh_cidr_blocks     = "ssh_cidr_blocks"
}
```

## Input Variables

| Variable Name       | Type   | Default      | Description                                        |
|---------------------|--------|--------------|----------------------------------------------------|
| nexus_ami_id        | string | -            | AMI ID for the Nexus instance                      |
| nexus_instance_type | string | t2.medium    | Instance type for Nexus instance                   |
| key_name            | string | -            | Key name for SSH access to the Nexus instance      |
| nexus_subnet_id     | string | -            | ID of the subnet for the Nexus instance            |
| nexus_sg_vpc_id     | string | -            | VPC ID for the Nexus Security group                |
| ssh_cidr_blocks     | list   | -            | CIDR blocks for SSH access                         |
| http_cidr_blocks    | list   | -            | CIDR blocks for HTTP access                        |

## Outputs

| Output Name          | Description                             |
|----------------------|-----------------------------------------|
| nexus_instance_id    | ID of the Nexus EC2 instance            |
| public_ip            | Public IP of the Nexus EC2 instance     |

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