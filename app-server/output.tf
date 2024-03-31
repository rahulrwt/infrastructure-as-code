output "instance_public_ip" {
  value = aws_autoscaling_group.app-server-asg.availability_zones
}