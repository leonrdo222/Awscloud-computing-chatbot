###############################################
# IAM Role for EC2
###############################################

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.project_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  # Added: Tags for better organization and cost tracking
  tags = {
    Name        = "${var.project_name}-ec2-role"
    Environment = "prod"  # Adjust as needed
  }
}

###############################################
# Custom ECR Policy (for explicit control)
###############################################

# Added: Custom policy document for ECR read access. This duplicates the managed policy but allows customization (e.g., add resource restrictions later).
data "aws_iam_policy_document" "ecr_read" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeRepositories"  # Added: Useful for debugging repo existence
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecr_read_custom" {
  name   = "${var.project_name}-ecr-read"
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.ecr_read.json
}

###############################################
# Attach AWS-managed policies
###############################################

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Removed: The managed ECR readonly attachment – replaced by custom policy above for flexibility. If you prefer managed, keep it and remove the custom.

###############################################
# Instance Profile
###############################################

resource "aws_iam_instance_profile" "this" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.ec2_role.name
}