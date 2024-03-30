
resource "aws_instance" "app-server" {
  ami           = local.app-server-ami
  instance_type = local.instance_type
  key_name      = local.aws-key-pair-name
  vpc_security_group_ids = [aws_security_group.cooking-corner-sg.id]
  tags = {
    Name = "application-server"
  }
}
