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
npm start &

# Install and run Node Exporter
cd ~
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar xvfz node_exporter-1.3.1.linux-amd64.tar.gz
cd node_exporter-1.3.1.linux-amd64

./node_exporter --web.listen-address "0.0.0.0:9101" &
