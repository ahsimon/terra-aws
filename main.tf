provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "demo" {
  ami           = "ami-08c40ec9ead489470"
  instance_type = "t3.nano"
  tags = {
    Name = "demo-aws"
  }
}
