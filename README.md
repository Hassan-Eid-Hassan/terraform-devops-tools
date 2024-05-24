<p align="center">
    <img width="350" src="https://media.licdn.com/dms/image/C4D12AQF3BC5EsIE_GQ/article-cover_image-shrink_720_1280/0/1604378518742?e=2147483647&v=beta&t=Pg5h7Dai90apcfagvy1N_IOj54p_S9hnMny3-R50NhA">
</p>
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
    This project contains Terraform code for provisioning DevOps tools and AWS infrastructure, including a VPC, Jenkins, Nexus, HA or none-HA Kubernetes, and EKS cluster. The configuration values can be customized using the <strong>terraform.tfvars</strong> file. 
</p>


## Table of Contents

- [Introduction](#introduction)
- [Navigation](#navigation)
- [Setup Instructions](#setup-instructions)
- [Configuration](#configuration)
- [Usage](#usage)
- [Security Considerations](#security-considerations)
- [Differences between EKS and Kubernetes Modules](#differences-between-eks-and-kubernetes-modules)
- [Contributing](#contributing)
- [Acknowledgments](#acknowledgments)

## Introduction

This project is designed to help you provision DevOps tools and AWS infrastructure using Terraform on AWS. The setup includes a Virtual Private Cloud (VPC), Jenkins, Nexus, Kubernetes, and an EKS cluster with node groups. All configurations are provided in the form of Terraform code.

The project is organized into several modules and files:

- modules/: Contains Terraform modules for different parts of the DevOps tools and infrastructure (e.g., VPC, EKS, Jenkins, Nexus, Kubernetes).
- main.tf: The main Terraform configuration file that defines the root module and ties together the various modules.
- provider.tf: Configures the AWS provider with the region and credentials.
- variables.tf: Defines input variables for the DevOps tools and infrastructure configuration.
- terraform.tfvars: Contains values for input variables, customizing the configuration for your environment.
- outputs.tf: Defines output variables for useful information about the provisioned infrastructure.

## Navigation

- **[VPC Module](modules/vpc)**: Contains the Terraform code for creating the VPC, subnets, and associated resources.
- **[Jenkins Module](modules/jenkins)**: Contains the Terraform code for provisioning a Jenkins instance.
- **[Nexus Module](modules/nexus)**: Contains the Terraform code for provisioning a Nexus instance.
- **[Kubernetes Module](modules/kubernetes)**: Contains the Terraform code for creating a Kubernetes cluster.
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

- **Kubernetes Values**
    - `k8s_cluster_name`: Name of the Kubernetes cluster.
    - `k8s_master_ami_id`: AMI ID for the Kubernetes master node.
    - `k8s_master_instance_type`: Instance type for the Kubernetes master node.
    - `k8s_worker_ami_id`: AMI ID for the Kubernetes worker nodes.
    - `k8s_worker_instance_type`: Instance type for the Kubernetes worker nodes.
    - `k8s_worker_min_capacity`: Minimum size for the worker auto-scaling group.
    - `k8s_worker_max_capacity`: Maximum size for the worker auto-scaling group.
    - `k8s_worker_desired_capacity`: Desired size for the worker auto-scaling group.

- **EKS Values**
    - Similar to Kubernetes values, with additional EKS-specific parameters.

Customize these variables according to your requirements.

## Differences between EKS and Kubernetes Modules

### EKS Module

- **EKS (Elastic Kubernetes Service):** This module provisions and manages a Kubernetes cluster using Amazon EKS, a fully managed Kubernetes service provided by AWS.
  
  - **Features:**
    - Fully managed service: AWS manages the Kubernetes control plane, ensuring high availability, scalability, and security.
    - Simplified cluster management: EKS handles cluster deployment, scaling, and maintenance tasks, allowing users to focus on application development.
    - Integration with AWS services: EKS seamlessly integrates with other AWS services, such as IAM for authentication, VPC for networking, and CloudWatch for monitoring.

### Kubernetes Module

- **Kubernetes:** This module provisions and manages a Kubernetes cluster using vanilla Kubernetes, an open-source container orchestration platform.
  
  - **Features:**
    - Customizable control: Users have full control over the Kubernetes cluster, including the deployment, configuration, and management of the control plane and worker nodes.
    - Flexibility: Since it's not tied to any specific cloud provider, vanilla Kubernetes can be deployed on any infrastructure, including on-premises servers or other cloud providers.
    - Community support: Vanilla Kubernetes benefits from a large and active open-source community, providing a wide range of plugins, tools, and integrations.
    - Customization: Users can customize and extend Kubernetes functionality using various plugins, operators, and extensions available in the Kubernetes ecosystem.

### Comparison

- **EKS:**
  - Fully managed service by AWS.
  - Streamlined deployment and management experience.
  - Integrated with AWS services.
  - Ideal for users who prefer a managed Kubernetes solution and want to leverage AWS's infrastructure and services.

- **Kubernetes:**
  - Self-managed Kubernetes cluster.
  - Provides maximum flexibility and control over the cluster configuration.
  - Can be deployed on any infrastructure.
  - Suitable for users who require extensive customization or want to avoid vendor lock-in by using a cloud-agnostic solution.

Choose between EKS and vanilla Kubernetes based on your specific requirements for management overhead, flexibility, and integration with other AWS services.

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