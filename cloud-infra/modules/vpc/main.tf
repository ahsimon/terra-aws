resource "aws_vpc" "cloud_network" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "Cloud Network"
    env = var.env
  }

}
