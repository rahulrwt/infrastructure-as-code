output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_instance_profile.name
  description = "Name of the IAM instance profile"
}

output "iam_role_name" {
  value = aws_iam_role.ec2_role.name
  description = "Name of the IAM role"
}

output "iam_role_arn" {
  value = aws_iam_role.ec2_role.arn
  description = "ARN of the IAM role"
}

output "iam_policy_arn" {
  value = aws_iam_policy.server_policy.arn
  description = "ARN of the IAM policy"
}