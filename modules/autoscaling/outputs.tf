output "asg_name" {
  value       = aws_autoscaling_group.asg.name
  description = "Name of the Auto Scaling Group"
}

output "launch_template_id" {
  value       = aws_launch_template.lt.id
  description = "Launch template ID"
}
