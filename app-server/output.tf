output "instance_public_ip" {
  value = aws_instance.app-server.public_ip
}