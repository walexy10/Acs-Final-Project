# variables.tf
variable "region" {
  type        = string
  description = "AWS region"
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
  default = "10.200.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
  default = "vpc"
}

variable "tags" {
  description = "map of tags to add to all resources"
  type        = map(string)
  default     = {
    Environment   = "Stg"
    Created_using = "Terraform"
    Group         = "Group19"
  }
}

variable "azs" {
  type        = list(any)
  description = "VPC CIDR block"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "web_subnet_cidr_private" {
  type        = list(any)
  description = "Private subnet CIDR blocks list"
  default = ["10.200.0.0/24", "10.200.1.0/24", "10.200.2.0/24"]
}

variable "lb_subnet_cidr_public" {
  type        = list(any)
  description = "Private subnet CIDR blocks list"
  default = ["10.200.3.0/24", "10.200.4.0/24", "10.200.5.0/24"]
}

variable "subnet_name_prefix" {
  type        = string
  default     = "subnet"
  description = "Prefix to generate subnet names"
}

variable "web_instance_ami" {
  type        = string
  description = "AMI"
  default = "ami-0b0dcb5067f052a63"
}

variable "web_instance_type" {
  type        = string
  description = "Web instance type"
  default = "t3.small"
}

# Bastion
variable "bastion_instance_ami" {
  type        = string
  description = "AMI"
  default = "ami-0b0dcb5067f052a63"
}

variable "bastion_instance_type" {
  type        = string
  description = "App instance type"
  default = "t3.micro"
}

variable "bastion_instance_name_prefix" {
  type        = string
  description = "App instance name prefix"
  default = "bastionStg"
}

variable "aws_ssh_key_pair" {
  type        = string
  description = "SSH key pair"
  default = "walexy_key"
}

variable "alb_listener_port" {
  type        = string
  description = "ALB listener port"
  default = "80"
}

variable "alb_listener_protocol" {
  type        = string
  description = "ALB listener protocol"
  default = "HTTP"
}

# Web instance ASG parameters

variable "web_instance_associate_public_ip" {
  type    = bool
  default = false
}

variable "web_instance_asg_max_instance_size" {
  type        = number
  description = "ASG max instance size"
  default = 4
}

variable "web_instance_asg_min_instance_size" {
  type        = number
  description = "ASG min instance size"
  default = 3
}

variable "web_instance_launch_config_name_prefix" {
  type        = string
  description = "Web instance launch config name prefix"
  default     = "webstg-"
}

variable "web_instance_asg_group_cpu_scale_out_threshold_precentage" {
  type        = string
  description = "ASG scaling group CPU threshold percentage"
  default = "10"
}

variable "web_instance_asg_group_cpu_scale_in_threshold_percentage" {
  type        = string
  description = "ASG scaling group CPU threshold percentage"
  default = "5"
}

variable "web_instance_scaling_adjustment" {
  type = number
  description = "Number of instances to scale"
  default = 1
}

# Environment prefixes
variable "environment_prefix" {
  type        = string
  description = "Environment Type"
  default = "Stg"
}

variable "group" {
  type        = string
  description = "Group to generate names of resources"
  default = "Group19"
}

# s3 bucket parameters
variable "s3_bucket_name" {
  type        = string
  description = "s3 bucket to hold index.html"
  default = "osaliu3finalproject3"
}
