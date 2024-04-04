locals {
  instance_type             = var.instance_type
  region                    = "ap-south-1"
  app-server-ami            = "ami-0287a05f0ef0e9d9a"
  aws-key-pair-name         = var.aws_key_pair_name
  cookingcorner_ec2_ami     = "ami-0287a05f0ef0e9d9a"
  subnet                    = "subnet-00c4e99c26398b671"
  user_data_script = <<-EOT
    #!/bin/bash

    echo "This script is running from Terraform"
    sudo su
    curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    apt-get update > /tmp/user_data_output1.txt
    apt-get install -y nodejs
    cd ~
    git clone https://github.com/rahulrwt/cooking-corner.git
    cd cooking-corner
    npm install
    npm start
  EOT
}