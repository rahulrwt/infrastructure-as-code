variable "ec2_role_name" {
  description = "Name of the IAM role for EC2"
  type = string
  default = "ec2-role"
}

variable "iam_policy_name" {
  description = "Name of the IAM policy"
  type = string
  default = "ec2-iam-policy"
}

variable "iam_policy_description" {
  description = "Description of the IAM policy"
  type = string
  default = "Server IAM policy"
}

variable "instance_profile_name" {
  description = "Name of the IAM instance profile"
  type = string
  default = "ec2_instance_profile"
}

variable "policy_actions" {
  description = "List of actions for the IAM policy"
  type = list(string)
  default = ["*"]
}

variable "policy_resources" {
  description = "List of resources for the IAM policy"
  type = list(string)
  default = ["*"]
}

variable "prefix" {
  description = "Prefix for resource names to uniquely identify the environment (e.g., staging, production)"
  type        = string
  default     = ""
}