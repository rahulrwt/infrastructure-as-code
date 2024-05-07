module "app-server" {
  source = "./app-server"
  instance_type = "t2.micro"
  aws_key_pair_name = aws_key_pair.app-server-keypair.key_name
}