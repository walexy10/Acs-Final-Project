# main.tf

# VPC
module "vpc" {

  source = "../../modules/vpc"

  vpc_name                = var.vpc_name
  vpc_cidr_block          = var.vpc_cidr_block
  azs                     = var.azs
  web_subnet_cidr_private = var.web_subnet_cidr_private
  lb_subnet_cidr_public   = var.lb_subnet_cidr_public
  alb_listener_port       = var.alb_listener_port
  environment_prefix      = var.environment_prefix
  group                   = var.group
  tags                    = var.tags
}


# Bastion Instance

module "bastion_instance" {

  source                 = "../../modules/bastion"
  ami                    = var.bastion_instance_ami
  instance_type          = var.bastion_instance_type
  subnet_id              = module.vpc.lb_public_subnet_ids
  aws_ssh_key_name       = var.aws_ssh_key_pair
  vpc_security_group_ids = [module.vpc.lb_security_group_id]
  instance_name_prefix   = var.bastion_instance_name_prefix
  environment_prefix     = var.environment_prefix
  group                  = var.group
  tags                   = var.tags

}



# Web Instance auto scaling group

module "web_instance_asg" {

  source = "../../modules/asg"

  aws_launch_config_name_prefix                = var.web_instance_launch_config_name_prefix
  aws_launch_config_image_id                   = var.web_instance_ami
  aws_launch_config_instance_type              = var.web_instance_type
  aws_launch_config_key_name                   = var.aws_ssh_key_pair
  aws_launch_config_associate_public_ip        = var.web_instance_associate_public_ip
  aws_launch_config_security_group             = [module.vpc.web_security_group_id]
  asg_max_instance_size                        = var.web_instance_asg_max_instance_size
  asg_min_instance_size                        = var.web_instance_asg_min_instance_size
  asg_instance_scaling_adjustment              = var.web_instance_scaling_adjustment
  azs                                          = var.azs
  asg_group_cpu_scale_out_threshold_precentage = var.web_instance_asg_group_cpu_scale_out_threshold_precentage
  asg_group_cpu_scale_in_threshold_percentage  = var.web_instance_asg_group_cpu_scale_in_threshold_percentage
  asg_group_vpc_zone_identifier                = module.vpc.web_private_subnet_ids
  s3_bucket_name                               = var.s3_bucket_name
  environment_prefix                           = var.environment_prefix
  group                                        = var.group
  tags                                         = var.tags
}

# Application load balancer

module "alb" {

  source = "../../modules/alb"

  vpc_security_group_ids = [module.vpc.lb_security_group_id]
  vpc_id                 = module.vpc.vpc_id
  target_id              = module.web_instance_asg.aws_autoscaling_group_id
  subnet_id              = module.vpc.lb_public_subnet_ids
  listener_port          = var.alb_listener_port
  listener_protocol      = var.alb_listener_protocol
  environment_prefix     = var.environment_prefix
  group                  = var.group
  tags                   = var.tags
}