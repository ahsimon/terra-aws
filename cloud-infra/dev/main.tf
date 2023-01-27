terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
  backend "s3" {
    encrypt = true
    bucket  = "mini-terraform-class-dev-state"

    key            = "terrraform-state/dev/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "mini-terraform-class-dev-lock"
  }
}



provider "aws" {
  region  = "us-east-2"
  profile = "default"
}


locals {
  env      = "dev"
  vpc_cidr = "10.0.0.0/16"
}

/* 
module "backend" {
  source   = "../modules/backend"
  env = local.env
} */




module "vpc" {
  source = "../modules/vpc"
  vpc_cidr    = local.vpc_cidr
}


resource "aws_instance" "public_server" {
  ami           = "ami-0a606d8395a538502"
  instance_type = "t2.micro"
  key_name      = "terraformclass"

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

resource "aws_dynamodb_table" "mini_terraform_state_lock" {
  name           = "mini-terraform-class-${local.env}-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    name = "Dynamo that stores the lock for Terraform"
    env  = local.env
  }

}
