###############################################
# Launch Template
###############################################

resource "aws_launch_template" "this" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = var.custom_ami_id        # ← Now uses the pre-baked AMI from Packer
  instance_type = var.instance_type

  #############################################
  # IAM role for EC2 (still needed for SSM and potential future use)
  #############################################
  iam_instance_profile {
    name = var.instance_profile_name
  }

  #############################################
  # Networking
  #############################################
  vpc_security_group_ids = [var.ec2_sg_id]

  #############################################
  # NO USER_DATA ANYMORE
  # The AMI already has Docker installed, image pulled, and chatbot.service enabled
  #############################################

  #############################################
  # Zero-downtime updates
  #############################################
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
  health_check_grace_period = 60  # ← Reduced: instance is ready in ~20-30 seconds

  #############################################
  # Launch Template attachment
  #############################################
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  #############################################
  # Instance tagging
  #############################################
  tag {
    key                 = "Name"
    value               = "${var.project_name}-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity]  # Keeps scaling policies from causing drift
  }
}