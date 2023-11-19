# Documentation

This markdown file provides a detailed guide to deploy two Amazon Linux 2 EC2 instances and one Ubuntu EC2 instance on AWS using Terraform. It includes a step-by-step deployment guide, prerequisites, and notes. The guide also provides code snippets for creating the necessary Terraform configuration files. Users can follow these instructions to create their infrastructure by copying and pasting the provided code snippets.

The guide also includes instructions for accessing the EC2 instances and cleaning up resources to prevent ongoing charges.

Please note that users should replace the `ami` IDs, `subnet_id`, `vpc_id`, and `key_name` with values that correspond to their AWS environment. Additionally, users can adjust the `instance_type` if a different EC2 instance size is required. The security group in this setup allows SSH, HTTP, and HTTPS traffic from any IP. Modify the CIDR blocks for a more restrictive setup.

use this command in shell "export ANSIBLE_HOST_KEY_CHECKING=False" to avoid host key checking when trying to ssh/ping more than one host at a time.

## Terraform AWS EC2 Deployment README

## Overview

This guide provides detailed steps to deploy two Amazon Linux 2 EC2 instances and one Ubuntu EC2 instance on AWS using Terraform. Each instance will have basic network access managed by a shared security group.

## Prerequisites

- An AWS account with necessary permissions.
- Terraform (v0.12 or higher) installed.
- AWS CLI installed and configured with appropriate credentials.

## Step-by-Step Deployment Guide

### Step 1: Initialize Terraform Workspace

1. Create a directory for your Terraform project:

   ```shell
   mkdir terraform-aws-ec2
   cd terraform-aws-ec2
   ```

2. Initialize the Terraform workspace:
   ```shell
   terraform init
   ```

### Step 2: Create Terraform Configuration Files

1. Create `main.tf` with the following content:

   ```hcl
   provider "aws" {
     region = "eu-west-2"
   }

   resource "aws_security_group" "my_sg" {
     name        = "ubuntu_server_sg"
     description = "Allow SSH, HTTP, and HTTPS"
     vpc_id      = "vpc-095a1ee516e12f7ba"

     ingress {
       from_port   = 22
       to_port     = 22
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
     }

     ingress {
       from_port   = 80
       to_port     = 80
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
     }

     ingress {
       from_port   = 443
       to_port     = 443
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
     }

     egress {
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       cidr_blocks = ["0.0.0.0/0"]
     }
   }

   resource "aws_instance" "ubuntu_server" {
     ami                    = "ami-0505148b3591e4c07"
     instance_type          = "t2.micro"
     subnet_id              = "subnet-0394725cdbfd85d65"
     vpc_security_group_ids = [aws_security_group.my_sg.id]
     key_name               = "cpdevopsew-eu-west-2"

     tags = {
       Name = "UbuntuServer"
     }
   }

   resource "aws_instance" "amazon_linux2_server" {
     count                   = 2
     ami                     = "ami-06d0baf788edae448"
     instance_type           = "t2.micro"
     subnet_id               = "subnet-0394725cdbfd85d65"
     vpc_security_group_ids  = [aws_security_group.my_sg.id]
     key_name                = "cpdevopsew-eu-west-2"

    <!-- This code block defines a Terraform tag for an Amazon Linux 2 server. The tag is named "Name" and its value is "AmazonLinux2Server-${count.index}". The count variable is used to generate a unique name for each server. -->
     tags = {
       Name = "AmazonLinux2Server-${count.index}"
     }
   }

   output "ubuntu_server_ip" {
     value = aws_instance.ubuntu_server.public_ip
   }

   output "amazon_linux2_server_ips" {
     value = aws_instance.amazon_linux2_server.*.public_ip
   }
   ```

2. (Optional) Create a `variables.tf` for defining any variables.

### Step 3: Deploy the Configuration

1. Generate an execution plan:

   ```shell
   terraform plan
   ```

   This shows the changes Terraform will make.

2. Apply the configuration to create the instances:
   ```shell
   terraform apply
   ```
   Confirm with `yes` when prompted.

### Step 4: Access the EC2 Instances

- After successful deployment, Terraform will output the public IPs of the EC2 instances.
- Use these IPs to SSH into your instances (ensure your key pair is correctly set up).

### Step 5: Clean Up Resources

- To prevent ongoing charges, you can destroy the resources:
  ```shell
  terraform destroy
  ```
  Confirm with `yes` to proceed.

---

## Notes

- Ensure you replace the `ami` IDs, `subnet_id`, `vpc_id`, and `key_name` with values that correspond to your AWS environment.
- Adjust the `instance_type` if a different EC2 instance size is required.
- The security group in this setup allows SSH, HTTP, and HTTPS traffic from any IP. Modify the CIDR blocks for a more restrictive setup.

This README provides a comprehensive guide to deploying a simple AWS EC2 setup using Terraform. Users can follow these instructions to create their infrastructure by copying and pasting the provided code snippets.
