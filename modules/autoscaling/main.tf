resource "aws_launch_template" "this" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [var.ec2_sg_id]

  user_data = base64encode(templatefile(
    "${path.module}/user_data_systemd.tpl",
    {
      ECR_REPO    = var.ecr_repo_url
      AWS_REGION  = var.aws_region
      APP_PORT    = var.app_port
      MODEL_S3_URI = var.model_s3_uri
    }
  ))
}

resource "aws_autoscaling_group" "this" {
  name                = "${var.project_name}-asg"
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity

  vpc_zone_identifier = var.subnet_ids
  target_group_arns  = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}
