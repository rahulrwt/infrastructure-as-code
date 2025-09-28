#!/bin/bash

# This script helps set up SMTP configuration for Grafana in Terraform

# Check if required commands are available
if ! command -v terraform &> /dev/null; then
    echo "Error: terraform command not found. Please install Terraform."
    exit 1
fi

# Ask for SMTP configuration
read -p "SMTP Host (e.g., smtp.gmail.com): " smtp_host
read -p "SMTP Port [587]: " smtp_port
smtp_port=${smtp_port:-587}
read -p "SMTP From Address (e.g., alerts@your-domain.com): " smtp_from_address
read -p "SMTP Username: " smtp_user
read -s -p "SMTP Password: " smtp_password
echo ""

# Generate a tfvars file for local testing
echo "Creating SMTP configuration for Terraform..."

cat > grafana-smtp.tfvars << EOF
smtp_host        = "${smtp_host}"
smtp_port        = ${smtp_port}
smtp_from_address = "${smtp_from_address}"
smtp_user        = "${smtp_user}"
smtp_password    = "${smtp_password}"
EOF

echo "Configuration saved to grafana-smtp.tfvars"
echo "Apply this configuration with: terraform apply -var-file=grafana-smtp.tfvars"

# Make the script executable
chmod +x "$0"

echo "Done! You can now use these SMTP settings with Terraform."