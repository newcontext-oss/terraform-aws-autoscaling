AWS Auto Scaling Group (ASG) Terraform module
================================================

Terraform module which creates Auto Scaling resources on AWS.

These types of resources are supported:

* [Launch Configuration](https://www.terraform.io/docs/providers/aws/r/launch_configuration.html)
* [Auto Scaling Group](https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html)

Root module calls these modules which can also be used separately to create independent resources:

* [launch_configuration](https://github.com/terraform-aws-modules/terraform-aws-autoscaling/tree/master/modules/launch_configuration) - creates Launch Configuration
* [autoscaling_group](https://github.com/terraform-aws-modules/terraform-aws-autoscaling/tree/master/modules/autoscaling_group) - creates Auto Scaling Group

Usage
-----

```hcl
module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Launch configuration
  lc_name = "example-lc"

  image_id        = "ami-ebd02392"
  instance_type   = "t2.micro"
  security_groups = ["sg-12345678"]

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "example-asg"
  vpc_zone_identifier       = ["subnet-1235678", "subnet-87654321"]
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "megasecret"
      propagate_at_launch = true
    },
  ]
}
```

Examples
--------

* [Auto Scaling Group without ELB](https://github.com/terraform-aws-modules/terraform-aws-autoscaling/tree/master/examples/asg_ec2)
* [Auto Scaling Group with ELB](https://github.com/terraform-aws-modules/terraform-aws-autoscaling/tree/master/examples/asg_elb)
* [Auto Scaling Group and Launch Configuration test fixture](https://github.com/terraform-aws-modules/terraform-aws-autoscaling/tree/master/examples/asg_lc_test_fixture)

Testing
--------

This module has been packaged with [awspec](https://github.com/k1LoW/awspec) tests through test kitchen and kitchen terraform. To run them:
1. Install [rvm](https://rvm.io/rvm/install) and the ruby version specified in the [Gemfile](https://github.com/terraform-aws-modules/terraform-aws-alb/tree/master/Gemfile).
2. Install bundler and the gems in Gemfile:
```
gem install bundler; bundle install
```
3. Ensure your AWS environment is configured (i.e. credentials and region). If your ~/.aws/credentials file is in place, ensure the desired AWS_PROFILE is set.
4. Test using `bundle exec kitchen test` from the root of the repo.

Authors
-------

Module managed by [Anton Babenko](https://github.com/antonbabenko).

License
-------

Apache 2 Licensed. See LICENSE for full details.
