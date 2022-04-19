terraform {
  required_version = ">= 0.12.31"

  required_providers {
    aws = "~> 4.8.0"
  }
}

provider "aws" {
  profile = "acg"
  region  = "us-east-2"

  default_tags {
    tags = {
      Certification = "Solutions Architect"
      Project       = "vpc_overview"
    }
  }
}
