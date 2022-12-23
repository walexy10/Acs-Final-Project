# asg.tf

data "template_file" "bootstrap" {
  template = file("${path.module}/userdata/init.sh")

  vars = {
    s3_bucket_name = var.s3_bucket_name
    html_path      = var.html_path
    html_file      = var.html_file
    image_file     = var.image_file
  }
}

# Creating the autoscaling launch configuration that contains AWS EC2 instance details
resource "aws_launch_configuration" "web" {
  name_prefix                 = var.aws_launch_config_name_prefix
  image_id                    = var.aws_launch_config_image_id
  instance_type               = var.aws_launch_config_instance_type
  key_name                    = var.aws_launch_config_key_name
  associate_public_ip_address = var.aws_launch_config_associate_public_ip
  security_groups             = var.aws_launch_config_security_group
  user_data                   = data.template_file.bootstrap.rendered

  lifecycle {
    create_before_destroy = true
  }

}

# Creating the autoscaling group
resource "aws_autoscaling_group" "web" {
  name                 = "${var.environment_prefix}-${var.group}-${var.aws_autoscaling_group_name}"
  launch_configuration = aws_launch_configuration.web.name
  max_size             = var.asg_max_instance_size
  min_size             = var.asg_min_instance_size
  enabled_metrics      = var.aws_autoscaling_group_enabled_metrics
  metrics_granularity  = var.aws_autoscaling_group_metrics_granularity
  vpc_zone_identifier  = var.asg_group_vpc_zone_identifier

  lifecycle {
    create_before_destroy = true
  }
}

# Creating the autoscaling policy
resource "aws_autoscaling_policy" "web_policy_up" {
  name                   = "${var.environment_prefix}-${var.group}_Web_Asg_Policy_Up"
  scaling_adjustment     = var.asg_instance_scaling_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name

}

# Creating the cloudwatch alarm
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name          = "${var.environment_prefix}-${var.group}_Web_Cpu_Alarm_Up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.asg_group_cpu_scale_out_threshold_precentage

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = ["${aws_autoscaling_policy.web_policy_up.arn}"]

  tags = merge(
    { "Name" = "${var.environment_prefix}-${var.group}_Web_Cpu_Alarm_Up" },
    var.tags,
  )
}

# Creating the autoscaling policy
resource "aws_autoscaling_policy" "web_policy_down" {
  name                   = "${var.environment_prefix}-${var.group}_Web_Asg_Policy_Down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name

}

# Creating the cloudwatch alarm
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name          = "${var.environment_prefix}-${var.group}_Web_Cpu_Alarm_Down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.asg_group_cpu_scale_in_threshold_percentage
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = ["${aws_autoscaling_policy.web_policy_down.arn}"]

  tags = merge(
    { "Name" = "${var.environment_prefix}-${var.group}_Web_Cpu_Alarm_Down" },
    var.tags,
  )
}