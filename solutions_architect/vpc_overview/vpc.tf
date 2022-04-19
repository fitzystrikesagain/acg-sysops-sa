locals {
  subnets = [
    "${data.aws_region.current.name}a",
    "${data.aws_region.current.name}b",
  ]
}

data "aws_region" "current" {}

resource "aws_vpc" "acloudguru" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name : "acloudguruVPC"
  }
}

resource "aws_subnet" "acg_subnet" {
  count                   = length(local.subnets)
  cidr_block              = "10.0.${count.index + 1}.0/24"
  vpc_id                  = aws_vpc.acloudguru.id
  availability_zone       = local.subnets[count.index]
  map_public_ip_on_launch = count.index % 2 == 0

  tags = {
    Name = "10.0.${count.index + 1}.0 - ${local.subnets[count.index]}"
  }
}

resource "aws_internet_gateway" "acg_gateway" {
  vpc_id = aws_vpc.acloudguru.id

  tags = {
    Name = "acg-igw"
  }
}
