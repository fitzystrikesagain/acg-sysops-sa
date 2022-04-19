locals {
  open_ports = [22, 80, 443]
}

data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_key_pair" "acg_key" {
  key_name = "acg"
}

data "aws_ami" "latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "sg_webserver" {
  ami                         = data.aws_ami.latest.id
  instance_type               = "t2.micro"
  key_name                    = data.aws_key_pair.acg_key.key_name
  user_data                   = file("webserver.sh")
  associate_public_ip_address = true
  vpc_security_group_ids      = [data.aws_security_group.default.id]
}

resource "aws_security_group_rule" "default" {
  count             = length(local.open_ports)
  cidr_blocks       = [var.home_cidr]
  from_port         = local.open_ports[count.index]
  protocol          = "tcp"
  security_group_id = data.aws_security_group.default.id
  to_port           = local.open_ports[count.index]
  type              = "ingress"
}

resource "aws_security_group_rule" "ping" {
  cidr_blocks       = [var.home_cidr]
  from_port         = 0
  protocol          = "-1"
  security_group_id = data.aws_security_group.default.id
  to_port           = 0
  type              = "ingress"
}



