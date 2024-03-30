# Created using sh-keygen -t rsa -b 4096 -I ap-south-1-ssh-key -f ap-south-1-ssh-key and uploaded it to s3 bucket
resource "aws_key_pair" "app-server-keypair" {
  key_name   = "app-server-keypair"
  public_key = file("ap-south-1-ssh-key.pub")
}