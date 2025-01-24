# Terraform Configurations for AWS Services

Welcome to the public repository for Terraform configuration files! This repository contains reusable and modular Terraform scripts for provisioning and managing various AWS services. It is designed to simplify your Infrastructure as Code (IaC) workflows and enable efficient AWS resource management.

## Features

- **Modular Configurations**: Easily adapt and reuse modules across different AWS services.
- **Well-Documented Code**: Clear and concise documentation for each configuration.
- **Scalable and Reliable**: Designed to handle scalable AWS infrastructure deployments.
- **Community Contributions**: Open to enhancements and improvements from the community.

## Prerequisites

- **Terraform**: Install Terraform [here](https://www.terraform.io/downloads).
- **AWS Account**: Ensure you have access to an AWS account.
- **AWS CLI**: Install and configure the AWS CLI [here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/HGSChandeepa/Terraform-Configurations-AWS.git
   cd Terraform-Configurations-AWS
   ```

2. Initialize Terraform in your working directory:
   ```bash
   terraform init
   ```

3. Modify the variables as needed in the `variables.tf` file or provide them through a `terraform.tfvars` file.

4. Apply the configurations to provision resources:
   ```bash
   terraform apply
   ```

5. Verify the deployed resources in the AWS Management Console.

## Repository Structure (we are working on this)

```
.
├── modules
│   ├── service-1
│   ├── service-2
│   └── service-n
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

- **modules/**: Contains modular configurations for individual AWS services.
- **main.tf**: Entry point for executing Terraform scripts.
- **variables.tf**: Defines configurable variables for the Terraform scripts.
- **outputs.tf**: Specifies outputs for the deployed resources.

## Contributing

We welcome contributions to this repository! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your changes.
3. Commit your changes and push them to your fork.
4. Open a pull request with a clear description of your changes.

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
Thank you for using this repository to streamline your AWS infrastructure management with Terraform!

