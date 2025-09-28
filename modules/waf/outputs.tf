output "web_acl_id" {
  description = "The ID of the WAF WebACL"
  value       = aws_wafv2_web_acl.main.id
}

output "web_acl_arn" {
  description = "The ARN of the WAF WebACL"
  value       = aws_wafv2_web_acl.main.arn
}

output "web_acl_name" {
  description = "The name of the WAF WebACL"
  value       = aws_wafv2_web_acl.main.name
}

output "web_acl_capacity" {
  description = "The web ACL capacity units (WCUs) currently being used by this web ACL"
  value       = aws_wafv2_web_acl.main.capacity
}

output "association_id" {
  description = "The ID of the WAF WebACL Association"
  value       = aws_wafv2_web_acl_association.main.id
}