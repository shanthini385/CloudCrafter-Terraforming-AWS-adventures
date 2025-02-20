# --------------------------------------------------
# Terraform Settings
# --------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # (Optional) Specify the required Terraform version
  # required_version = ">= 1.0.0"
}

# --------------------------------------------------
# AWS Provider Configuration
# --------------------------------------------------
provider "aws" {
  region = "us-west-2"   # Changt to your preferred region
}
# --------------------------------------------------
# VPC
# --------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# --------------------------------------------------
# Public Subnet
# --------------------------------------------------
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"  # Adjust if needed
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}
# --------------------------------------------------
# Internet Gateway
# --------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# --------------------------------------------------
# Public Route Table
# --------------------------------------------------
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

# --------------------------------------------------
# Route Table Association
# --------------------------------------------------
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
# --------------------------------------------------
# Security Group
# --------------------------------------------------
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
# --------------------------------------------------
# EC2 Instance
# --------------------------------------------------
resource "aws_instance" "web_server" {
  ami           = "ami-065212a60f30e3798"  # Amazon Linux 2 AMI in us-east-1 (update if needed)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Provide an existing key pair name, or create one in the AWS console
  key_name = "my-key-pair"

  tags = {
    Name = "web-server"
  }

  # Optional user data to install a simple web server
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello, World from Terraform!" > /var/www/html/index.html
              EOF
}
