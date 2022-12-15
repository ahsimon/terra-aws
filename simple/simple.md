# Simple Server

```sh
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

```

For each type of provider, there are many different kinds of resources that you can create, such as servers, databases, and load balancers. The general syntax for creating a resource in Terraform is:

```sh
resource "<PROVIDER>_<TYPE>" "<NAME>" {
  [CONFIG ...]
}
```

PROVIDER: name of a provider : "aws"<br>
TYPE: Type of resource to create in that provider: "instance"<br>
NAME:  Identifier you can use throughout the Terraform code to refer to this resource<br>
CONFIG: One or more arguments that are specific to that resource

```sh
terraform init
```
terraform init to tell Terraform to scan the code, figure out which providers you’re using, and download the code for them. By default, the provider code will be downloaded into a .terraform folder, which is Terraform’s scratch directory (you may want to add it to .gitignore). Terraform will also record information about the provider code it downloaded into a .terraform.lock.hcl file. The command is idempotent

```sh
terraform plan
```
The plan command lets you see what Terraform will do before actually making any changes

```sh
terraform apply
```

To actually create the Instance. To actually create the Instance. The apply command shows you the same plan output and asks you to confirm whether you actually want to proceed with this plan (type yes)