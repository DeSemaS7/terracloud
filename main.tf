provider "aws" {
  region = "us-west-2"
}
terraform {
  backend "s3" {
    bucket = "terrabucket.desema"
    key    = "infra/terraform.tfstate"
    region = "us-west-2"
    encrypt = true
  }
}
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
locals {
  instance_type_map = {
    stage = "t2.nano"
    prod = "t2.micro"
  }[terraform.workspace]

  instance_count_map = {
    stage = 1
    prod = 2
  }[terraform.workspace]

  instances_foreach = {
    stage =    {
      "t2.nano" = "ami-0cf6f5c8a62fa5da6"
    }
    prod = {
    "t2.micro" = "ami-0cf6f5c8a62fa5da6"
    "t2.nano" = "ami-0cf6f5c8a62fa5da6"
    }

  }[terraform.workspace]
}


resource "aws_instance" "test" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type_map
  count = local.instance_count_map

  tags = {
    Name = "Ubuntu"
  }
}

resource "aws_instance" "test-amazon" {
  for_each = local.instances_foreach
  ami = each.value
  instance_type = each.key

  tags = {
    Name = "Amazon Linux 2"
  }

  lifecycle {
    create_before_destroy = true
  }
}
