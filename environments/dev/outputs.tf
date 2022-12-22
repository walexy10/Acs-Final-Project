# outputs.tf

output "bastion_public_ip" {
  value = module.bastion_instance.instance_ip
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

