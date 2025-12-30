###############################################
# Launch Template (Golden AMI)
###############################################

resource "aws_launch_template" "this" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = var.custom_ami_id        # ← Pre-baked AMI from Packer
  instance_type = var.instance_type

  #############################################
  # IAM role for EC2 (SSM + future use)
  #############################################
  iam_instance_profile {
    name = var.instance_profile_name
  }

  #############################################
  # Networking
  #############################################
  vpc_security_group_ids = [var.ec2_sg_id]

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
  health_check_grace_period = 60  # Fast detection — Golden AMI boots quickly

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
    ignore_changes = [desired_capacity]  # Prevents drift from scaling policies
  }
}