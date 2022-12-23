# alb.tf

# Create Applicaion load balancer
resource "aws_lb" "alb" {
  name                       = "${var.environment_prefix}-${var.group}-Alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.vpc_security_group_ids
  subnets                    = var.subnet_id
  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(
    { "Name" = "${var.environment_prefix}-${var.group}-Alb" },
    var.tags,
  )
}

# Create Applicaion load balancer target group
resource "aws_lb_target_group" "alb" {
  name = "${var.environment_prefix}-${var.group}-Alb-Tg"

  port     = var.listener_port
  protocol = var.listener_protocol
  vpc_id   = var.vpc_id

  stickiness {
    type = "lb_cookie"
  }

  health_check {
    path = "/"
    port = 80
  }

  tags = merge(
    { "Name" = "${var.environment_prefix}-${var.group}-Alb-Tg" },
    var.tags,
  )
}

# Create Applicaion load balancer ASG attachment
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = var.target_id
  lb_target_group_arn    = aws_lb_target_group.alb.arn

}

# Create Applicaion load balancer listener
resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }

  tags = merge(
    { "Name" = "${var.environment_prefix}-${var.group}-Alb-Listener" },
    var.tags,
  )
}
