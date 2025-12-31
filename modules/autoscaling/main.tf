###############################################
# Launch Template
###############################################

resource "aws_launch_template" "this" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [var.ec2_sg_id]

  user_data = base64encode(
    templatefile(
      "${path.module}/user_data_systemd.tpl",
      {
        ECR_REPO   = var.ecr_repo_url
        AWS_REGION = var.aws_region
        APP_PORT   = var.app_port
      }
    )
  )

  lifecycle {
    create_before_destroy = true
  }
}

###############################################
# Auto Scaling Group
###############################################

resource "aws_autoscaling_group" "this" {
  name             = "${var.project_name}-asg"
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = [var.target_group_arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300  # Plenty of time for full bootstrap

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }
}