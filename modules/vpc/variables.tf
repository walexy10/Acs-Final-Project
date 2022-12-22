# variables.tf


variable "vpc_cidr_block" {
  type = string
  description = "VPC CIDR block"
}

variable "anywhere" {
  type = string
  default = "0.0.0.0/0"
}

variable "ssh_port" {
  type = string
  description = "SSH port"
  default = "22"
}

variable "alb_listener_port" {
  type        = string
  description = "ALB listener port"
}

variable "vpc_name" {
  type = string
  description = "VPC name"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "web_subnet_cidr_private" {
  type = list(any)
  description = "Private subnet CIDR blocks list"
}

variable "lb_subnet_cidr_public" {
  type = list(any)
  description = "Private subnet CIDR blocks list"
}

variable "azs" {
  type        = list(any)
  description = "VPC CIDR block"

}

variable "subnet_name_prefix" {
  type = string
  default = "subnet"
  description = "Prefix to generate subnet names"
}

variable "enable_nat_gateway" {
  type = bool
  default = true
  description = "Whether to create NAT Gateway"
}

variable "enable_internet_gateway" {
  type = bool
  default = true
  description = "Whether to create Internet Gateway"
}

variable "environment_prefix" {
  type = string
  description = "Environment Type"
}

variable "group" {
  type = string
  description = "Group to generate names of resources"
}