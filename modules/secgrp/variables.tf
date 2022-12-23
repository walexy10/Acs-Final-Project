# variables.tf


variable "vpc_id" {
  type = string
  description = "VPC Id"
}

variable "alb_listener_port" {
  type        = string
  description = "ALB listener port"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "environment_prefix" {
  type = string
  description = "Environment Type"
}

variable "group" {
  type = string
  description = "Group to generate names of resources"
}