output "instance_profile_name" {
  value       = aws_iam_instance_profile.ec2_profile.name
  description = "Name of the EC2 instance profile"
}

output "role_name" {
  value       = aws_iam_role.ec2_role.name
  description = "EC2 IAM role name"
}
