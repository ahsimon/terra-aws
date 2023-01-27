
# Cloud Infra

This is another production ready infrastructure cloud AWS and Terraform


# Notes 

Terraform is really based around managing the state of our infrastucture. Its declarative configuration language is really good for that. 

terraform.tfstate Has the entire  available set of information declared about AWS

```sh
#validates that terraform.tfstate is synchronized with aws
terraform refresh 
```

When we collaborate with our team. tstate file can be unmatched.  Terraform give us a tool to manage our infrastucture state betted, that mechanism is called backend. That is a S3 bucket, that terraform can use it to store the state file. Also DynamoDB can be used as locking mechanism to tsfile. 



