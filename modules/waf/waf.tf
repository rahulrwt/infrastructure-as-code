resource "aws_wafv2_web_acl" "main" {
  name        = var.waf_name
  description = "WAF Web ACL for application load balancer"
  scope       = "REGIONAL"
  default_action {
    allow {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.app_name}-waf"
    sampled_requests_enabled   = true
  }
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  custom_response_body {
    key          = "ratelimit"
    content_type = "TEXT_HTML"
    content      = jsonencode({ error = "You are rate limited please try after some time" })
  }

  custom_response_body {
    key          = "Testing"
    content_type = "APPLICATION_JSON"
    content      = jsonencode({ error = "You are rate limited please try after some time" })
  }

  rule {
    name     = "RateBasedRule"
    priority = 1
    action {
      block {
        custom_response {
          response_code            = 200
          custom_response_body_key = "ratelimit"
        }
      }
    }
    statement {
      rate_based_statement {
        limit              = 300
        aggregate_key_type = "IP"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateBasedRule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 2
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }
}


# Optional IP set for blocking specific IPs
resource "aws_wafv2_ip_set" "blocked_ips" {
  count              = length(var.blocked_ip_addresses) > 0 ? 1 : 0
  name               = "${var.waf_name}-blocked-ips"
  description        = "Blocked IP addresses"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.blocked_ip_addresses
  tags               = var.tags
}

# Association between WAF and Application Load Balancer
resource "aws_wafv2_web_acl_association" "main" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

# First create the log group
resource "aws_cloudwatch_log_group" "waf_logs" {
  count             = var.enable_logging ? 1 : 0
  name              = "aws-waf-logs-${var.waf_name}"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

# Then configure the logging - fixed the ARN format
resource "aws_wafv2_web_acl_logging_configuration" "main" {
  count                   = var.enable_logging ? 1 : 0
  resource_arn            = aws_wafv2_web_acl.main.arn
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs[0].arn]
  redacted_fields {
    single_header {
      name = "authorization"
    }
  }
  depends_on = [aws_cloudwatch_log_group.waf_logs]
}