output "region" {
  description = "Outputting the region as a dummy value."
  value       = "${var.region}"
}

output "asg_name" {
  description = "Autoscaling group name."
  value       = "${module.asg_lc.this_autoscaling_group_name}"
}

output "lc_name" {
  description = "Autoscaling group name."
  value       = "${module.asg_lc.this_autoscaling_group_launch_configuration}"
}
