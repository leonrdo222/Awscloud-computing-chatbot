output "repository_url" {
  description = "Full ECR repository URI (used by EC2 user-data and CI/CD)"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_name" {
  description = "ECR repository name"
  value       = aws_ecr_repository.this.name
}

output "repository_arn" {
  description = "ECR repository ARN"
  value       = aws_ecr_repository.this.arn
}
