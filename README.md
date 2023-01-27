# terra-aws

:rocket: Playing with Terraform

## Terraform Cheat Sheet
| Command |  Description|
| --- | --- |
| `terraform init`|  Its the first command you need to execute. Unless, terraform play, apply, destroy and import will not work <br>The command **terraform init** will install: <ul><li>terraform modules</li><li>eventually a backend</li><li>providers plugins</li></ul>|
| `terraform get` | This command is useful when you have defined some modules. Modules are vendored so when you edit them, you need to get again modules content. <br>When you use modules, the fist thing you have to do is  **terraform get** This pulls modules into the .terraform directory. Once you do that, unless you do another ```terraform get -update true```, you've essentially vendored those modules| 
| `terraform plan` | The **plan** step checks configuration to execute and write a plan to apply to target infrastructure provider. <br> Its important feature of terraform that allows a user to see which actions terraform will perform, prior to making any changes, increasing confidence that a change will have the desired effect once applied|
| `terraform apply` | Now you have the desired state, so you can execute the **plan** <br> Since terraform v0.11+ in an interactive mode, you can just execute `terraform apply` command which will print out which actions TF will perform.<br>By generating the plan and applying it in the same command, terraform can guarantee that the execution plan won´t change without to needed to write it to disk. This reduces the risk of potentially sensitive data being left behind or accidentally checked into version control  |
`terraform destroy` |destroys all resources|
`terraform graph` |will generate the visual graph of your infrastructure based on Terraform configuration files |

<br>

### Examples

Init terraform and dont ask any input:
```sh 
terraform init -input=false
```

Change backend configuration during init:

```sh
terraform init -backend-config=cfg/s3.dev.tf -reconfigure
```
`reconfigure` option is used to tell terraform to not copy the existing state to the new remote state location

Check the plan:
```sh 
terraform plan -out plan.out
```
 When you execute terraform plan command, terraform will scan all *.tf files in your directory and create a plan

Apply the plan:
```sh 
terraform apply plan.out
```

Apply and auto approve:
```sh 
terraform apply --auto-approve
```

Apply and define new variables values:
```sh 
terraform apply --auto-approve -var tags=repository-url=${GIT_URL}
```
Apply only one module
```sh 
terraform apply -target=module.s3
```

`target` option works with terraform plan too


##  Installing and configuring Terraform
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
export AWS_SECRET_ACCESS_KEY=(aws secret access key)
```

## Basic Scenarios

[Deploying a Docker Image](/docker/docker.md)

[Deploying a Simple Server](/simple/simple.md)

[Deploying a HTTP Server](/httpserver/httpserver.md)

[Production Ready Cloud Infrastructure](/cloud-infra/cloud-infra.md)