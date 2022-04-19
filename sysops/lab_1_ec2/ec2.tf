data "aws_key_pair" "lab_key" {
  key_name = "lab_key"
}

data "aws_ami" "latest_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "lab" {
  ami                         = data.aws_ami.latest_ami.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = data.aws_key_pair.lab_key.key_name
  subnet_id                   = aws_subnet.default_subnet[0].id
  user_data                   = file("webserver.sh")
  vpc_security_group_ids      = [aws_vpc.default.default_security_group_id]
}