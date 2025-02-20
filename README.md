=====================================================================
Terraform & AWS Infrastructure Project - Step-by-Step Guide
=====================================================================

Overview:
---------
This project uses Terraform to provision a basic AWS infrastructure.
It creates a VPC, subnet, Internet Gateway, Route Table, Security Group,
and an EC2 instance. Additionally, it sets up a DNS record in Route 53
to map a friendly URL to the EC2 instance's public IP. This guide
documents all steps from setting up credentials to deploying and
verifying your infrastructure.

Prerequisites:
--------------
1. AWS Account
   - Ensure you have an active AWS account.
2. AWS CLI Installed & Configured
   - Install the AWS CLI.
   - Run: aws configure
   - Provide your:
     - AWS Access Key ID
     - AWS Secret Access Key
     - Default Region (e.g., us-west-2)
     - Default Output Format (e.g., json)
   - Verify with: aws sts get-caller-identity
3. Terraform Installed
   - Download Terraform from https://terraform.io/downloads
   - Verify with: terraform -v
4. IAM User with Sufficient Permissions
   - Use an IAM user with AdministratorAccess (or proper permissions)
   - Create an IAM user for Terraform and download its access keys if needed.
5. (Optional) AWS Key Pair for EC2
   - Create a key pair in the EC2 console (e.g., "my-key-pair")
   - Download the PEM file for SSH access.

Project Setup:
--------------
1. Create Project Directory
   - mkdir my_aws_project
   - cd my_aws_project

2. Create main.tf File
   - Use your favorite text editor to create and edit main.tf

Terraform Configuration (main.tf):
------------------------------------
# Terraform Settings & AWS Provider
--------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"  # Change to your desired region
}

# VPC Configuration
--------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Public Subnet
--------------------------------------------------
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"  # Use a valid AZ in us-west-2
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Internet Gateway
--------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Public Route Table
--------------------------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate Route Table with Subnet
--------------------------------------------------
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group (Allow SSH & HTTP)
--------------------------------------------------
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# EC2 Instance
--------------------------------------------------
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux.id  # See data source below
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name      = "my-key-pair"  # Ensure this key exists in your region

  tags = {
    Name = "web-server"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello, World from Terraform!" > /var/www/html/index.html
              EOF
}

# Data Source: Latest Amazon Linux 2 AMI
--------------------------------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

# (Optional) Route 53 DNS Record
--------------------------------------------------
# Create or reference an existing hosted zone
data "aws_route53_zone" "my_zone" {
  name         = "example.com"  # Replace with your domain name
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.my_zone.zone_id
  name    = "www.example.com"  # Replace with your desired DNS name
  type    = "A"
  ttl     = 300
  records = [aws_instance.web_server.public_ip]
}

Deployment:
-----------
1. Initialize Terraform:
   Command: terraform init

2. Review the Execution Plan:
   Command: terraform plan

3. Apply the Configuration:
   Command: terraform apply
   - When prompted, type "yes" to confirm.
   
4. Verify in AWS Console:
   - Check EC2 for your instance.
   - Verify VPC, subnet, and security group under the respective sections.
   - Check Route 53 for your DNS record.
   - In your browser, visit http://www.example.com (or the domain you configured).

Cleanup:
--------
To remove all resources created by Terraform:
   Command: terraform destroy
   - Confirm by typing "yes" when prompted.

Additional Notes:
-----------------
- The AWS Access Key and Secret used for 'aws configure' are stored in ~/.aws/credentials.
- Make sure your key pair (my-key-pair) exists in the region you are deploying.
- If you are using a custom domain, update your registrar's name servers to point to Route 53.
- Adjust CIDR blocks, instance types, and AMI IDs as needed for your environment.
- For production environments, use more secure IAM policies and limit access as needed.

=====================================================================
End of Guide
=====================================================================
