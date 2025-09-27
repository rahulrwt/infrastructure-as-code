locals {
  instance_type             = var.instance_type
  region                    = "ap-south-1"
  app-server-ami            = "ami-0287a05f0ef0e9d9a"
  aws-key-pair-name         = var.aws_key_pair_name
  cookingcorner_ec2_ami     = "ami-0287a05f0ef0e9d9a"
  subnet                    = "subnet-00c4e99c26398b671"
  user_data_script          = file("${path.module}/user_data.sh")
}