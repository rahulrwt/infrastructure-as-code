variable "waf_name" {
  description = "Name for the WAF Web ACL"
  type        = string
  default     = "${var.app_name}-waf"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = ""
}

variable "alb_arn" {
  description = "ARN of the Application Load Balancer to associate with the WAF"
  type        = string
}

variable "rate_limit" {
  description = "Request limit for rate-based rule (requests per 5 minutes)"
  type        = number
  default     = 2000
}

variable "blocked_ip_addresses" {
  description = "List of IP addresses to block (CIDR notation)"
  type        = list(string)
  default     = []
}

variable "enable_logging" {
  description = "Enable WAF logging to CloudWatch"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain WAF logs"
  type        = number
  default     = 30
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}