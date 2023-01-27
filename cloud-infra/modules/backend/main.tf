resource "aws_s3_bucket" "mini_terraform_backend" {
  bucket = "mini-terraform-class-${var.env}-state"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
 
  }
tags ={
    Name = "mini Remote terraform backend"
    env = var.env
} 

}

