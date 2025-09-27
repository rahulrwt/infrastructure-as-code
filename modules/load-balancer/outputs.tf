output "target_group_arns" {
    value = [aws_lb_target_group.green_tg.arn]
}

output "lb_dns" {
   value = aws_lb.app_lb.dns_name
}

output "lb_arn" {
   value = aws_lb.app_lb.arn
   description = "ARN of the Application Load Balancer"
}