resource "aws_ecr_repository" "this" {
  name                 = "${var.project_name}-chatbot"
  image_tag_mutability = "MUTABLE"

  # Allow terraform destroy without manual image cleanup (OPTIONAL but useful)
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name    = "${var.project_name}-chatbot"
    Project = var.project_name
    Managed = "terraform"
  }
}
