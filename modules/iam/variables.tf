###############################################
# IAM Module Variables
###############################################

variable "project_name" {
  description = "Project name prefix for IAM resources"
  type        = string
  default     = "leonow"  # Added: Default to prevent empty prefix errors during testing
  validation {
    condition     = length(var.project_name) > 0
    error_message = "Project name cannot be empty."
  }
}