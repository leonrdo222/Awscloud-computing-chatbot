output "alb_sg_id" {
  value       = aws_security_group.alb_sg.id
  description = "ALB security group ID"
}

output "ec2_sg_id" {
  value       = aws_security_group.ec2_sg.id
  description = "EC2 instances security group ID"
}
