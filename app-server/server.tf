data "aws_s3_bucket_object" "key_pair_name" {
  bucket = "cooking-corner-codepipeline"
  key    = "EC2_key_pair/server_keys.pem"
}

resource "aws_instance" "app-server" {
  ami           = local.app-server-ami
  instance_type = local.instance_type
  key_name      = data.aws_s3_bucket_object.key_pair_name.body
  vpc_security_group_ids = [aws_security_group.cooking-corner-sg.id]
  tags = {
    Name = "application-server"
  }
}
