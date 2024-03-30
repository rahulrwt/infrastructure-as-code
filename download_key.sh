#!bin/bash

aws s3 cp s3://infrastructure-as-code-bucket/credentials/EC2_keys/ap-south-1-ssh-key.pub ap-south-1-ssh-key.pub
aws s3 cp s3://infrastructure-as-code-bucket/credentials/EC2_keys/ap-south-1-ssh-key.pub ap-south-1-ssh-key
chmod 600 ap-south-1-ssh-key