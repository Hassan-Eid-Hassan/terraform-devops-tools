# Terraform Project: Jenkins, EKS, and Nexus Infrastructure on AWS

This Terraform project sets up a complete infrastructure on AWS, including Jenkins, EKS, and Nexus services. The infrastructure includes a VPC with two subnets, and places the Jenkins and Nexus instances in the same subnet. The EKS cluster contains one master and two worker nodes.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Installation and Setup](#installation-and-setup)
- [Usage](#usage)
- [Cleaning Up](#cleaning-up)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

- [Terraform](https://learn.hashicorp.com/tutorials/terraform/installing-cli) v1.0.0 or higher.
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials and region.
- An AWS account with the necessary permissions to deploy infrastructure.
- An SSH key pair set up in AWS (you'll need the key name for the configuration).

## Project Structure

The project is structured as follows:

- `modules/`: Contains separate Terraform modules for each service (Jenkins, EKS, Nexus, and VPC).
- `scripts/`: Contains installation scripts for Jenkins and Nexus.
- `main.tf`: Main Terraform configuration file that references the modules.
- `variables.tf`: Contains input variable definitions.
- `outputs.tf`: Contains output variable definitions.
- `terraform.tfvars`: Contains default values for input variables.

## Installation and Setup

1. Clone this repository to your local machine.

    ```shell
    git clone <repository-url>
    ```

2. Change to the project directory.

    ```shell
    cd <project-directory>
    ```

3. Edit the `terraform.tfvars` file and update the values according to your AWS configuration, including the key name for SSH access.

4. Initialize the Terraform project.

    ```shell
    terraform init
    ```

## Usage

After the project is initialized, you can plan and apply the deployment.

- **Plan** the deployment to review the changes that will be made:

    ```shell
    terraform plan -var-file=terraform.tfvars
    ```

- **Apply** the deployment to create the infrastructure:

    ```shell
    terraform apply -var-file=terraform.tfvars
    ```

- Once the deployment is complete, you can use the output values to access your deployed services:
    - Jenkins is available at `http://<jenkins-public-ip>:8080/`
    - Nexus is available at `http://<nexus-public-ip>:8081/`
    - Use the kubeconfig file provided in the outputs to access your EKS cluster.

## Cleaning Up

To remove the deployed infrastructure, you can destroy the Terraform deployment:

```shell
terraform destroy -var-file=terraform.tfvars
