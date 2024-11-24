terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = {
      Name = "LearningNginx"
    }
  }
}

variable "ssh_public_key_file" {
  description = "Path to the SSH public key file"
  type        = string
  default     = ".keys/ec2.pub"
}

data "local_file" "ssh_public_key_file_input" {
  filename = var.ssh_public_key_file
}

variable "ubuntu_22_04" {
  description = "Ubuntu Jammy 22.04 AMI"
  type        = string
  default     = "ami-066902f7df67250f8"
}

// probably wrong
data "http" "my_ip" {
  url = "http://checkip.amazonaws.com/"
}

resource "aws_vpc" "vpc_nginx" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "subnet_nginx" {
  cidr_block = cidrsubnet(aws_vpc.vpc_nginx.cidr_block, 3, 1)
  vpc_id     = aws_vpc.vpc_nginx.id
}

resource "aws_security_group" "nginx_security_group" {
  name        = "nginx-ec2-sg"
  description = "Allow inbound traffic for SSH and HTTP/HTTPS only from my IP"
  vpc_id      = aws_vpc.vpc_nginx.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   description = "Allow HTTP"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/32"]
  # }

  # ingress {
  #   description = "Allow HTTPS"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   # cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  #   cidr_blocks = ["0.0.0.0/32"]
  # }
}

// https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
resource "aws_key_pair" "ssh-key" {
  key_name = "ssh-key"
  # public_key = data.local_file.ssh_public_key_file_input.content
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDjagVPzVTnSD49l2CF2xtduyWQJm6lquT0/l1kvErpGy7cIdo5l6OVxT75MxFSkfQDcKP23AT6QI5WOtYe8+6VEa5kl7nQeNHxsbtKyVGuBgJG0R9P6ftdaijFCRA+4gEzRW6i/5JNRA7A3MZ3YA46ZJgPyHxSJn3tCqXURfsriZMj6pNPs5n8nbqBcZPaffI2rluXf+Tnx0/x9h40+hLQ+XB5rt1HWSkPiV8TXrxZM1RcpDtpPZxqPPc0RrzqZQyJqUa6Y1IBqFdSY3mvPMRi1pBZOKC0BIFUPocAE6bHS2zPTXYzSInd+vrtDphPPjFLLIN9UyiqGN8Iagkqf3jTY73UN2Qf6bGf0FjVOirYXdtr8tzXR6qeMFcZjiEEx0IZBx0WM9CWv0keUVAmkKfgqCQNRx92qbLrLMVMScaOsOmpRFCUrgNP60GNxO9kFK6/kpsU3AgxBbdjnjNLr5gBkRPFEzyWtbjWdj1Yxxfd8gEqsZ8EXs2qHmhmkkfG0rJ63MAFP15H4pnKYxOz84v2IWXZEYmCa6D0fbay+AXWC0Jj9chgQZaO5i+n8UaHDd37iwD8k2BUjQfucC/U6EEu1dQxIfyEXn5AeEBPl+W4oobDBAoLJIH8Sfxzb2UdYtQ3yx3mbat+THgyTvfdCNsGRJI+Ma8LpttzMeqkrArFHQ== plozovik@lozovikov"
}

resource "aws_instance" "ec2_nginx" {
  ami                         = var.ubuntu_22_04
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "ssh-key"
  security_groups             = ["${aws_security_group.nginx_security_group.id}"]
  subnet_id                   = aws_subnet.subnet_nginx.id
}

resource "aws_eip" "eip_nginx" {
  instance = aws_instance.ec2_nginx.id
  domain   = "vpc"
}

resource "aws_internet_gateway" "gw_nginx" {
  vpc_id = aws_vpc.vpc_nginx.id
}

resource "aws_route_table" "route-table-test-env" {
  vpc_id = aws_vpc.vpc_nginx.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_nginx.id
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.subnet_nginx.id
  route_table_id = aws_route_table.route-table-test-env.id
}

output "nginx_instance_eip_public_dns" {
  description = "Public DNS of EIP of the Nginx EC2 instance for SSH connection"
  value       = aws_eip.eip_nginx.public_dns
}
