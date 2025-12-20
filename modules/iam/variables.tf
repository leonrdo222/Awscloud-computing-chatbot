variable "project_name" {
  type = string
}

variable "model_s3_arns" {
  description = "S3 ARNs EC2 can read for model artifacts"
  type        = list(string)
}
