output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs used by the ALB and ASG"
  value       = module.vpc.public_subnet_ids
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "alb_domain_name" {
  description = "Domain name pointing to the ALB"
  value       = module.alb.alb_domain_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.autoscaling.asg_name
}
