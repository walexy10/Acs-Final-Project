# outputs.tf

output "aws_autoscaling_group_id" {
  value = aws_autoscaling_group.web.id
}

