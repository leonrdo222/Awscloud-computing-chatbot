###############################################
# IAM Outputs
###############################################

output "instance_profile_name" {
  description = "IAM instance profile name for EC2"
  value       = aws_iam_instance_profile.this.name
}

# Added: Output the role ARN for easier reference/debugging in other modules (e.g., autoscaling)
output "ec2_role_arn" {
  description = "ARN of the EC2 IAM role"
  value       = aws_iam_role.ec2_role.arn
}