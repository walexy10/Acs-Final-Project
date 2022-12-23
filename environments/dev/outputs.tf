# outputs.tf

output "bastion_public_ip" {
  value = aws_instance.bastion_instance.public_ip
}

output "load_balancer_dns_name" {
  value = module.alb.alb_dns_name
}

