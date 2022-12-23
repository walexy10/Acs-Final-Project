# Ouputs

output "web_security_group_id" {
  value = aws_security_group.aws-web-sg.id
}

output "lb_security_group_id" {
  value = aws_security_group.aws-lb-sg.id
}