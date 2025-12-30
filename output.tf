###############################################
# Root Outputs
###############################################

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.autoscaling.asg_name
}

output "launch_template_id" {
  description = "ID of the Launch Template (useful for debugging)"
  value       = module.autoscaling.launch_template_id
}