variable "prefix" {
  description = "Prefix to be used for resource naming to uniquely identify the environment (e.g., staging, production)"
  type        = string
  default = ""
}

variable "create_release_bucket" {
  description = "Flag to create the release artifact bucket"
  type        = bool
  
}

variable "create_dashboard_bucket" {
  description = "Flag to create the deployment dashboard bucket"
  type        = bool
  default     = false
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = ""
}