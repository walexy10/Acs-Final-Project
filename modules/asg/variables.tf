# variables.tf

variable "aws_launch_config_name_prefix" {
  type        = string
  description = ""
  default     = "web-"
}

variable "aws_launch_config_image_id" {
  type        = string
  description = ""
}

variable "aws_launch_config_instance_type" {
  type        = string
  description = ""
}

variable "aws_launch_config_key_name" {
  type        = string
  description = ""
}

variable "aws_launch_config_associate_public_ip" {
  type        = bool
  description = ""
  default     = true
}

variable "azs" {
  type        = list(any)
  description = "VPC CIDR block"

}

variable "asg_max_instance_size" {
  type        = number
  description = "ASG instance max size"
}

variable "asg_min_instance_size" {
  type        = number
  description = "ASG instance min size"
}

variable "asg_group_cpu_scale_out_threshold_precentage" {
  type        = string
  description = "ASG CPU scale out percentage"
}

variable "asg_group_cpu_scale_in_threshold_percentage" {
  type        = string
  description = "ASG CPU scale in percentage"
}

variable "asg_instance_scaling_adjustment" {
  type = number
  description = "Number of instances by which to scale"
}

variable "aws_autoscaling_group_name" {
  type        = string
  description = "AWS autoscaling group name"
  default     = "webautoscalegroup"
}

variable "aws_autoscaling_group_enabled_metrics" {
  type        = list(string)
  description = "List of AWS autoscaling group enabled metrics"
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
}

variable "aws_autoscaling_group_metrics_granularity" {
  type        = string
  description = "AWS autoscaling group metrics granularity"
  default     = "1Minute"
}

variable "asg_group_vpc_zone_identifier" {
  type        = list(string)
  description = "ASG VPC subnet ids"
}

variable "s3_bucket_name" {
  type        = string
  description = "s3 bucket to hold index.html"
}

variable "environment_prefix" {
  type        = string
  description = "Environment Type"
}

variable "group" {
  type        = string
  description = "Group to generate names of resources"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "html_path" {
  type        = string
  description = "html path for index.html on http server"
  default     = "/var/www/html"
}

variable "html_file" {
  type        = string
  description = "html path for index.html on http server"
  default     = "index.html"
}

variable "image_file" {
  type        = string
  description = "html path for index.html on http server"
  default     = "html5.gif"
}

variable "aws_launch_config_security_group" {
  type        = list(string)
  description = "AWS Launch config security group"
}