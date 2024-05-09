<h2 align="center">
    <img wide="500" src="https://media.licdn.com/dms/image/C4D12AQF3BC5EsIE_GQ/article-cover_image-shrink_720_1280/0/1604378518742?e=2147483647&v=beta&t=Pg5h7Dai90apcfagvy1N_IOj54p_S9hnMny3-R50NhA" alt="TerraformAWS Logo">
</h2>
<p align="center">
    <h1 align="center">Provisioning DevOps Tools and AWS Infrastructure with Terraform</h1>
</p>
<h3 align="center">
    <img src="https://img.shields.io/github/license/Hassan-Eid-Hassan/terraform-devops-tools?logoColor=white&label=License&color=F44336" alt="License Badge">
    <img src="https://img.shields.io/github/last-commit/Hassan-Eid-Hassan/terraform-devops-tools?style=flat&logo=git&logoColor=white&color=FFFFFF" alt="Last Commit Badge">
    <img src="https://img.shields.io/github/languages/top/Hassan-Eid-Hassan/terraform-devops-tools?style=flat&color=000000" alt="Top Language Badge">
    <img src="https://img.shields.io/github/languages/count/Hassan-Eid-Hassan/terraform-devops-tools?style=flat&color=000000" alt="Language Count Badge">
</h3>

<p align="left">
    This project contains Terraform code for provisioning DevOps tools and AWS infrastructure, including a VPC, Jenkins, Nexus, and EKS cluster. The configuration values can be customized using the <strong>terraform.tfvars<strong> file. 
</p>


## Table of Contents

- [Introduction](#introduction)
- [Navigation](#navigation)
- [Setup Instructions](#setup-instructions)
- [Configuration](#configuration)
- [Usage](#usage)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [Acknowledgments](#acknowledgments)

## Introduction

This project is designed to help you provision DevOps tools and AWS infrastructure using Terraform on AWS. The setup includes a Virtual Private Cloud (VPC), Jenkins, Nexus, and an EKS cluster with node groups. All configurations are provided in the form of Terraform code.

The project is organized into several modules and files:

- modules/: Contains Terraform modules for different parts of the DevOps tools and infrastructure (e.g., VPC, EKS, Jenkins, Nexus).
- main.tf: The main Terraform configuration file that defines the root module and ties together the various modules.
- provider.tf: Configures the AWS provider with the region and credentials.
- variables.tf: Defines input variables for the DevOps tools and infrastructure configuration.
- terraform.tfvars: Contains values for input variables, customizing the configuration for your environment.
- outputs.tf: Defines output variables for useful information about the provisioned infrastructure.

## Navigation

- **[VPC Module](modules/vpc)**: Contains the Terraform code for creating the VPC, subnets, and associated resources.
- **[Jenkins Module](modules/jenkins)**: Contains the Terraform code for provisioning a Jenkins instance.
- **[Nexus Module](modules/nexus)**: Contains the Terraform code for provisioning a Nexus instance.
- **[EKS Module](modules/eks)**: Contains the Terraform code for creating the EKS cluster and associated resources.

## Setup Instructions

1. Clone the repository:
    ```shell
    git clone https://github.com/Hassan-Eid-Hassan/terraform-devops-tools.git
    cd terraform-devops-tools
    ```

2. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).

3. Configure AWS credentials:
    - Make sure your AWS credentials are properly configured in your environment. You can use [AWS CLI](https://aws.amazon.com/cli/) or provide credentials via environment variables.

## Configuration

Customize the Terraform variables by modifying `terraform.tfvars` to suit your specific requirements. The `terraform.tfvars` file contains several variables that allow you to customize the DevOps tools and AWS infrastructure:

- **General Values**
    - `key_name`: Name of the SSH key pair to use for EC2 instances.
    - `ssh_key_path`: Path to the private key file for SSH access.
    - `ssh_cidr_blocks`: A list of CIDR blocks allowed to connect via SSH.
    - `http_cidr_blocks`: A list of CIDR blocks allowed to connect via HTTP.

- **VPC Values**
    - `vpc_name`: Name of the VPC.
    - `igw_name`: Name of the internet gateway.
    - `router_table_name`: Name of the route table.
    - `vpc_cidr_block`: CIDR block for the VPC.
    - `public_subnet_cidrs`: A list of CIDR blocks for public subnets.
    - `private_subnet_cidrs`: A list of CIDR blocks for private subnets.
    - `azs`: Availability zones to use.

- **Jenkins Values**
    - `jenkins_instance_type`: EC2 instance type for Jenkins.
    - `jenkins_ami_id`: AMI ID for Jenkins instance.
    - `jenkins_instance_user`: Default username for SSH access.

- **Nexus Values**
    - `nexus_instance_type`: EC2 instance type for Nexus.
    - `nexus_ami_id`: AMI ID for Nexus instance.
    - `nexus_instance_user`: Default username for SSH access.

- **EKS Values**
    - `cluster_name`: Name of the EKS cluster.
    - `eks_helper_node_name`: Name of the helper node for EKS.
    - `eks_node_group_template_name`: Template name for EKS node groups.
    - `node_group_name`: Name of the EKS node group.
    - `eks_version`: Version of EKS to use.
    - `helper_node_ami_id`: AMI ID for the helper node.
    - `helper_instance_type`: EC2 instance type for the helper node.
    - `node_group_instance_type`: List of EC2 instance types for node groups.
    - `node_group_ami_id`: AMI ID for the node groups.
    - `min_size`: Minimum number of nodes in the group.
    - `max_size`: Maximum number of nodes in the group.
    - `desired_size`: Desired number of nodes in the group.
    - `disk_size`: Disk size in GB for the nodes.
    - `capacity_type`: Capacity type for nodes (e.g., ON_DEMAND).

Customize these variables according to your requirements.

## Usage

1. Initialize Terraform:
    ```shell
    terraform init
    ```

2. Plan the changes:
    ```shell
    terraform plan
    ```

3. Apply the changes:
    ```shell
    terraform apply
    ```

## Security Considerations

- Ensure your AWS credentials are managed securely.
- Limit access to resources using security groups and IAM policies.
- Follow AWS best practices for securing your infrastructure.

## Contributing

Contributions are welcome! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch with your changes.
3. Submit a pull request explaining your changes.

## Acknowledgments

Thank you for using this project! If you have any questions or feedback, feel free to open an issue in the repository. Your contributions and suggestions are always welcome.