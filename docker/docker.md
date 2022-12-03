# Docker Server

[Terraform documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli?in=terraform%2Faws-get-started)
```sh
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}

```

Initialize the project

```sh
terraform init   
```
Provisioning the NGINX Server
```sh
terraform apply
```
Verify NGNX container at [localhost:8000](http://localhost:8000)

Destroy the server
```sh
terraform destroy
```