output "launch_template_id" {
  value = aws_launch_template.app-server-template.id
}

output "app_server_asg_name" {
  value = aws_autoscaling_group.app-server-asg.name
}

output "subnet" {
  value = local.subnet
}