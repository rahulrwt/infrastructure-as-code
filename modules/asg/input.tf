variable "instance-type" {
  description = "Instance type of server"
  type        = string
  default     = "t3.micro"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
}
variable "app-server-ami" {
  description = "AMI to be used by the app server"
  type = string
}

variable "aws-key-pair-name" {
  description = "AWS key to be assigend to the app-server"
  type = string
}

variable "aws_region" {
  description = "Region in which resource will be created"
  type = string
}

variable "max_bid" {
  description = "Max cost to pay for spot instance"
  type = string
}

variable "spot_instance_option" {
  description = "Instance type for spot if primary isnt available"
  type = string
}

variable "target_group_arns" {
    description = "ARN of the target group"
    type = list(string)
}

variable "subnet_ids" {
    description = "Subnet ids for ASG"
    type = list(string)
}

variable "asg_sg_ids" {
    description = "Security group ids for ASG"
    type = list(string) 
}

variable "iam_instance_profile_name" {
    description = "Name of the IAM instance profile"
    type = string
  
}

variable "asg_name" {
    description = "Name of the ASG"
    type = string
}

variable "environment_type" {
    description = "Environment type (e.g., staging, production), its case sensitive and should be in lowercase"
    type        = string
}

variable "prefix" {
    description = "Resource name prefix to identify environment (e.g., staging, production)"
    type        = string
    default     = ""
}
variable "s3_region" {
    description = "S3 region for App"
    type        = string
}

variable "s3_access_key" {
    description = "S3 access key for App"
    type        = string
}

variable "s3_secret_key" {
    description = "S3 secret key for App"
    type        = string
}