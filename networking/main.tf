
provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "microservices" {
  cidr_block       = "10.0.0.0/21"
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "microservices"
  }
}

resource "aws_vpc" "datastores" {
  cidr_block       = "10.0.8.0/23"
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "datastores"
  }
}

resource "aws_subnet" "public-a" {
  vpc_id     = aws_vpc.microservices.id
  cidr_block = "10.0.0.0/24"


  tags = {
    Name = "public-a"
  }
}


resource "aws_subnet" "public-b" {
  vpc_id     = aws_vpc.microservices.id
  cidr_block = "10.0.2.0/24"


  tags = {
    Name = "public-b"
  }
}

resource "aws_subnet" "public-c" {
  vpc_id     = aws_vpc.microservices.id
  cidr_block = "10.0.3.0/24"


  tags = {
    Name = "public-c"
  }
}


resource "aws_subnet" "private-cluster-a" {
  vpc_id     = aws_vpc.microservices.id
  cidr_block = "10.0.4.0/24"


  tags = {
    Name = "private-cluster-a"
  }
}


resource "aws_subnet" "private-cluster-b" {
  vpc_id     = aws_vpc.microservices.id
  cidr_block = "10.0.5.0/24"


  tags = {
    Name = "private-cluster-b"
  }
}

resource "aws_subnet" "private-cluster-c" {
  vpc_id     = aws_vpc.microservices.id
  cidr_block = "10.0.6.0/24"


  tags = {
    Name = "private-cluster-c"
  }
}


resource "aws_internet_gateway" "microservices_internet" {


  tags = {
    Name = "microservices_internet"
  }
}

resource "aws_internet_gateway_attachment" "microservices_internet" {
  internet_gateway_id = aws_internet_gateway.microservices_internet.id
  vpc_id              = aws_vpc.microservices.id


}


resource "aws_route_table" "public_traffic" {
  vpc_id = aws_vpc.microservices.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.microservices_internet.id
  }


 route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.microservices_internet.id
  }
  tags = {
    Name = "public_traffic"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.public_traffic.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.public_traffic.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public-c.id
  route_table_id = aws_route_table.public_traffic.id
}

resource "aws_nat_gateway" "public_nat" {
  allocation_id = aws_eip.public_nat.id
  subnet_id     = aws_subnet.public-a.id

  tags = {
    Name = "public_nat"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.microservices_internet]
}




resource "aws_eip" "public_nat" {
  vpc = true
}


resource "aws_route_table" "egress-only-internet_traffic" {
  vpc_id = aws_vpc.microservices.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.public_nat.id
  }

    route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_egress_only_internet_gateway.egress_only_microservices.id
  }



  tags = {
    Name = "egress-only-internet_traffic"
  }
}

resource "aws_egress_only_internet_gateway" "egress_only_microservices" {
  vpc_id = aws_vpc.microservices.id



  tags = {
    Name = "egress_only_microservices"
  }
}


data "aws_vpc_endpoint_service" "s3" {
  service      = "s3"
  service_type = "Gateway"
}



# Create a VPC endpoint
resource "aws_vpc_endpoint" "vpce" {
  vpc_id       = aws_vpc.microservices.id
  service_name = data.aws_vpc_endpoint_service.s3.service_name
    tags = {
    Name = "vpce"
  }
}


data "aws_vpc_endpoint" "s3" {
  vpc_id       =aws_vpc.microservices.id
  service_name = "com.amazonaws.us-east-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  vpc_endpoint_id = data.aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.egress-only-internet_traffic.id
}


resource "aws_network_acl" "public-traffic" {
  vpc_id = aws_vpc.microservices.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

    ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  tags = {
    Name = "public-traffic"
  }
}

resource "aws_network_acl_association" "public-traffic-a" {
  network_acl_id = aws_network_acl.public-traffic.id
  subnet_id      = aws_subnet.public-a.id
}

resource "aws_network_acl_association" "public-traffic-b" {
  network_acl_id = aws_network_acl.public-traffic.id
  subnet_id      = aws_subnet.public-b.id
}

resource "aws_network_acl_association" "public-traffic-c" {
  network_acl_id = aws_network_acl.public-traffic.id
  subnet_id      = aws_subnet.public-c.id
}



resource "aws_security_group" "alb-api" {
  name        = "alb-api"
  description = "Application  load balancer security"
  vpc_id      = aws_vpc.microservices.id

  ingress {
    description      = "HTTP Traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

   ingress {
    description      = "HTTPs Traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "alb-api"
  }
}


# resource "aws_vpc_peering_connection" "microservices-to-datastores" {
#   peer_owner_id = var.peer_owner_id
#   peer_vpc_id   = aws_vpc.microservices.id
#   vpc_id        = aws_vpc.datastores.id

# }