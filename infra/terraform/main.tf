terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "banking_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "banking-vpc"
  }
}

# Subnet A
resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.banking_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-a"
  }
}

# Subnet B
resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.banking_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-b"
  }
}

# Security Group allowing SSH, HTTP, NodePort
resource "aws_security_group" "banking_sg" {
  name        = "banking-sg"
  description = "Allow SSH, HTTP, and NodePort traffic"
  vpc_id      = aws_vpc.banking_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NodePort range"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "banking-sg"
  }
}

# Jenkins EC2 Instance
resource "aws_instance" "jenkins" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = "jenkins-key"
  subnet_id                   = aws_subnet.subnet_a.id
  vpc_security_group_ids      = [aws_security_group.banking_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Jenkins-Server"
  }
}

# Kubernetes Node 1
resource "aws_instance" "k8s_node_1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_b.id
  vpc_security_group_ids = [aws_security_group.banking_sg.id]

  tags = {
    Name = "k8s-node-1"
  }
}

# Kubernetes Node 2
resource "aws_instance" "k8s_node_2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.banking_sg.id]

  tags = {
    Name = "k8s-node-2"
  }
}
