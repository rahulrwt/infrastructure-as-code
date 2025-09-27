# Created using sh-keygen -t rsa -b 4096 -I app-server-ssh-key -f app-server-ssh-key and uploaded it to s3 bucket
resource "aws_key_pair" "app-server-keypair" {
  key_name   = "app-server-keypair"
  public_key = file("app-server-ssh-key.pub")
}

# Created using sh-keygen -t rsa -b 4096 -I prometheus-ssh-key -f prometheus-ssh-key and uploaded it to s3 bucket
resource "aws_key_pair" "prometheu-server-keypair" {
  key_name   = "app-server-keypair"
  public_key = file("prometheus-ssh-key.pub")
}