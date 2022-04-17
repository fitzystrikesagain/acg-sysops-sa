resource "aws_vpc" "default" {
  cidr_block           = "172.31.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

/*
vpc
route table
nacl
sg
*/

//
locals {
  azs = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
  ]
}
resource "aws_internet_gateway" "default_igw" {
  vpc_id = aws_vpc.default.id
}

resource "aws_subnet" "default_subnet" {
  count                   = length(local.azs)
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "172.31.${count.index + 1}.0/24"
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true
}

//resource "aws_network_acl" "default_nacl" {
//  vpc_id = aws_vpc.default.id
//  subnet_ids = [
//    aws_subnet.subnet-us-east-1a.id,
//    aws_subnet.subnet-us-east-1b.id,
//    aws_subnet.subnet-us-east-1c.id,
//    aws_subnet.subnet-us-east-1d.id,
//    aws_subnet.subnet-us-east-1e.id,
//    aws_subnet.subnet-us-east-1f.id,
//  ]
//
//  ingress {
//    from_port  = 0
//    to_port    = 0
//    rule_no    = 100
//    action     = "allow"
//    protocol   = "-1"
//    cidr_block = "0.0.0.0/0"
//  }
//
//  egress {
//    from_port  = 0
//    to_port    = 0
//    rule_no    = 100
//    action     = "allow"
//    protocol   = "-1"
//    cidr_block = "0.0.0.0/0"
//  }
//}
//
//resource "aws_route_table" "default_route" {
//  vpc_id = aws_vpc.default.id
//
//  route {
//    cidr_block = "0.0.0.0/0"
//    gateway_id = aws_internet_gateway.default-igw.id
//  }
//}
//
//resource "aws_security_group" "lab_sg" {
//  name        = "lab_sg"
//  description = "lab assignment VPC security group"
//  vpc_id      = aws_vpc.default.id
//
//  ingress {
//    from_port       = 0
//    to_port         = 0
//    protocol        = "-1"
//    cidr_blocks     = ["136.49.54.194/32"]
//    security_groups = []
//    self            = true
//  }
//
//  egress {
//    from_port   = 0
//    to_port     = 0
//    protocol    = "-1"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//}
resource "aws_security_group_rule" "ingress_from_home" {
  cidr_blocks       = ["136.49.54.194/32"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_vpc.default.default_security_group_id
  to_port           = 0
  type              = "ingress"
}

resource "aws_route" "internet_egress" {
  route_table_id         = aws_vpc.default.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default_igw.id
}

resource "aws_vpc" "non-default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}