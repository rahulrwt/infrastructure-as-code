# output "launch_template_id" {
#   value = aws_launch_template.app_server_template.id
# }

# output "app_server_asg_name" {
#   value = aws_autoscaling_group.app-server-asg.name
# }

output "load_balancer_dns" {
  value = module.load_balancer.lb_dns
}

output "rds_url" {
  value = module.rds.rds_endpoint
  
}