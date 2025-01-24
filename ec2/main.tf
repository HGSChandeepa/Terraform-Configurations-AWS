terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Variable for the instance name
variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
  default     = "terraform-example"
}

# Data source to find existing instances with the specified name
data "aws_instances" "existing_instances" {
  filter {
    name   = "tag:Name"
    values = [var.instance_name]
  }
}

# Create a new instance only if there are no existing instances
resource "aws_instance" "web" {
  count         = length(data.aws_instances.existing_instances.ids) == 0 ? 1 : 0
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = var.instance_name
  }

  lifecycle {
    prevent_destroy = true
  }
}
