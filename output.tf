output "app_server_launch_template_id" {
  value = module.app-server.launch_template_id
}

output "app_server_asg_name" {
  value = module.app-server.app_server_asg_name
}
output "app_server_subnet" {
  value = module.app-server.subnet
}