# terra-aws

:rocket: Playing with Terraform

## Terraform Cheat Sheet
| Command |  Description|
| --- | --- |
| ```terraform init```|  Its the first command you need to execute. Unless, terraform play, apply, destroy and import will not work <br>The command **terraform init** will install: <ul><li>terraform modules</li><li>eventually a backend</li><li>providers plugins</li></ul>|
| ```terraform get``` | This command is useful when you have defined some modules. Modules are vendored so when you edit them, you need to get again modules content. When you use modules, the fist thing you have to do is  **terraform get**. This pulls modules into the terraform directory. Once you do that, unless you do another ```terraform get -update true```|you've essentially vendored those modules| 
| ```terraform plan``` | The **plan** step check configuration to execute and write a plan to apply to target infrastructure provider. <br> Its important feature of terraform that allows a user to see which actions terraform will perform, prior to making any changes, increasing confidence that a change will have the desired effect once applied|



### Examples

init terraform and dont ask any input:
```sh 
terraform init -input=false
```

change backend configuration during init:

```sh
terraform init -backend-config=cfg/s3.dev.tf -reconfigure
```
`reconfigure` is used to tell terraform to not copy the existing state to the new remote state location

check the plan:
```sh 
terraform plan -out plan.out
```
 When you execute terraform plan command, terraform will scan all *.tf files in your directory and create a plan
 



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

3. Configure AWS env vars

```sh
  export AWS_ACCESS_KEY_ID=(aws access key id)
  export AWS_SECRET_ACCES_KEY=(aws secret access key)
```

## Basic Scenarios

[Deploying a Docker Image](/docker/docker.md)

[Deploying a Simple Server](/simple/simple.md)
