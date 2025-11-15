output "target_group_arn" {
  value       = aws_lb_target_group.tg.arn
  description = "ARN of the ALB target group"
}

output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "DNS name of the ALB"
}

output "alb_arn" {
  value       = aws_lb.alb.arn
  description = "ARN of the ALB"
}

output "alb_domain_name" {
  value       = aws_route53_record.alb_dns.fqdn
  description = "Domain name pointing to ALB"
}
