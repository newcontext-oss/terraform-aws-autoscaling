terraform {
  required_version = ">= 0.10.0"
}

data "aws_availability_zones" "available" {}

provider "aws" {
  region  = "${var.region}"
  version = ">= 1.0.0"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-2017.09.1.20171120-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  name               = "test-vpc"
  cidr               = "10.0.0.0/16"
  azs                = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = true
  tags               = {}
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"
  name   = "test-sg-https"
  vpc_id = "${module.vpc.vpc_id}"
}

module "asg_lc" {
  source = "../../"

  lc_name         = "test-lc"
  image_id        = "${data.aws_ami.amazon_linux.id}"
  instance_type   = "t2.nano"
  security_groups = ["${module.security_group.this_security_group_id}"]

  # Auto scaling group
  asg_name            = "test-asg"
  vpc_zone_identifier = ["${module.vpc.public_subnets}"]
  health_check_type   = "EC2"
  min_size            = 0
  max_size            = 1
  desired_capacity    = 1

  tags = [
    {
      key                 = "Environment"
      value               = "test"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "test-instance"
      propagate_at_launch = true
    },
  ]
}
