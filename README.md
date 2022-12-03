# terra-aws

:rocket: Playing with Terraform


## Prerequisites: Installing and configuring Terraform
Please review the [Terraform Documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli?in=terraform%2Faws-get-started)

1. Installing in Ubuntu/Debian

```sh
  sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
```
```sh
  wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
```
```sh
  gpg --no-default-keyring \
  --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  --fingerprint
```
```sh
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list
```
```sh
  sudo apt update
  ```
```sh  
  sudo apt-get install terraform
```

2. Setup an AWS Account

* Sing up on https://aws.amazon.com
* Go to [IAM Console](https://amzn.to/33fM2jf)
* Add a user with Access key - Programmatic access
* Set `AdministratorAccess` privileges to this user

1. Configure AWS env vars

```sh
  export AWS_ACCESS_KEY_ID=(aws access key id)
  export AWS_SECRET_ACCES_KEY=(aws secret access key)
```

## Basic Scenarios

[Deploying a Docker Image](/docker/main.tf)

[Deploying a Simple Server](/simple/simple.md)
