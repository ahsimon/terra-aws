terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}


resource "aws_instance" "public_server" {
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = "t3.nano"
  key_name = "terraformclass"
  
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "public_server"
  }
}
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allows ssh connections and access to internet"


  ingress = [{
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh ingress"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    self        = false

    ipv6_cidr_blocks = []
    security_groups  = []
    prefix_list_ids  = []

  }]

  egress = [{
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    to_port     = 0
    from_port   = 0
    description = "internet egress"

    ipv6_cidr_blocks = []
    self             = false
    prefix_list_ids  = []
    security_groups  = []
  }]
}
