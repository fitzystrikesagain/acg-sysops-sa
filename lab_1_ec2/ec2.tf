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

////resource "aws_network_interface" "eni-07c325361c208a1f6" {
////    subnet_id         = "subnet-087175fac1ecfef7a"
////    private_ips       = ["172.31.90.249"]
////    security_groups   = ["sg-0b2c7ce21ff7abce6"]
////    source_dest_check = true
////    attachment {
////        instance     = "i-0670695e70906c397"
////        device_index = 0
////    }
////}
////
