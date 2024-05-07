#!bin/bash 
terraform output -json > output.json
aws s3 cp output.json s3://cooking-corner-terraform-s3/output.json
