provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "httpserver" {
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = "t3.nano"
  vpc_security_group_ids = [aws_security_group.httpserver.id]

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF

  tags = {
    Name = "httpserver"
  }
}


resource "aws_security_group" "httpserver" {
  name = "httpserver"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
