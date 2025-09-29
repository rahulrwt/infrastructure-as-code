#!/bin/bash
sudo apt update
sudo apt install -y openjdk-17-jdk jq
java --version
# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install -y unzip
unzip awscliv2.zip
sudo ./aws/install
aws --version
# Create necessary directories
sudo mkdir -p /opt/app
sudo chmod 755 /opt/app
# Download file from s3
aws s3 cp s3://${app_name}-release-artifact/release-versions.json /opt/app/release-versions.json || { echo "Failed to download release-versions.json"; exit 1; }
# Verify file existence
if [[ -f /opt/app/release-versions.json ]]; then
 cat /opt/app/release-versions.json
else
 echo "release-versions.json not found"
fi

#Set Environment Variable
echo "${env_vars_script}" | sudo tee /etc/${app_name}.env > /dev/null

# Set active profile based on environment variable
ACTIVE_PROFILE="prod"
if [ "${environment}" = "staging" ]; then
  ACTIVE_PROFILE="staging"
fi
echo "Setting active profile to: $ACTIVE_PROFILE"

# Extract version using jq
if command -v jq >/dev/null 2>&1; then
  if [ -f /opt/app/release-versions.json ]; then
    if [ "$ACTIVE_PROFILE" = "staging" ]; then
      KEY="staging-${app_name}"
    else
      KEY="${app_name}"
    fi
    echo "Key is : $KEY"
    RELEASE_VERSION=$(jq -r --arg key "$KEY" '.[$key]' /opt/app/release-versions.json 2>/dev/null || echo "")
    
    if [[ -n "$RELEASE_VERSION" && "$RELEASE_VERSION" != "null" ]]; then
      echo "Extracted version: $RELEASE_VERSION"
      export VERSION="$RELEASE_VERSION"
    else
      echo "Failed to extract version for key '$KEY'"
      exit 1
    fi
  else
    echo "Cannot extract version - file not found"
    exit 1
  fi
else
  echo "jq is not installed"
  exit 1
fi
# Download and place the latest JAR file
aws s3 cp s3://${app_name}-release-artifact/${app_name}.$RELEASE_VERSION.jar /opt/app/${app_name}.jar || { echo "Failed to download ${app_name}.$RELEASE_VERSION.jar"; exit 1; }
aws s3 cp s3://${app_name}-secrets/whatsapp-private-key/private_pkcs8.pem /opt/app/private_pkcs8.pem || { echo "Failed to download private_pkcs8.pem"; exit 1; }
# Create app user and group
sudo useradd -r -s /bin/false ${app_name}
sudo mkdir -p /var/log/${app_name}
sudo chown -R ${app_name}:${app_name} /var/log/${app_name} /opt/app
sudo chmod 750 /var/log/${app_name}

# Record instance start time
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
START_TIME=$(date +%Y%m%d-%H%M%S)
echo "$START_TIME" > /opt/app/instance_start_time

# Create shutdown script to upload logs to S3 when instance terminates
# Create file with environment placeholder
cat > /opt/app/upload-logs-on-shutdown.sh << 'END_OF_SCRIPT'
#!/bin/bash
# Don't use set -e since we want to continue even if some commands fail
set -e 

# Set up logging
LOGFILE="/tmp/upload-logs-script.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "=== Starting log upload script at $(date) ==="
echo "Running as user: $(whoami)"

# Get instance metadata with timeout to prevent hanging
echo "Fetching instance metadata..."
TOKEN=$(curl -s --connect-timeout 3 --max-time 3 -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" || echo "")
echo "Metadata token retrieval complete"

if [ -z "$TOKEN" ]; then
  echo "Warning: Failed to get metadata token, using fallback values"
  INSTANCE_ID="unknown-instance"
  REGION="us-east-1"
else
  echo "Got token, retrieving instance ID..."
  INSTANCE_ID=$(curl -s --connect-timeout 3 --max-time 3 -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id || echo "unknown-instance")
  echo "Got token, retrieving region..."
  REGION=$(curl -s --connect-timeout 3 --max-time 3 -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region || echo "us-east-1")
fi

echo "Instance ID: $INSTANCE_ID"
echo "Region: $REGION"

# Get start time and calculate end time
if [ -f /opt/app/instance_start_time ]; then
  START_TIME=$(cat /opt/app/instance_start_time)
  echo "Start time: $START_TIME"
else
  START_TIME="unknown"
  echo "Warning: Start time file not found, using 'unknown'"
fi

END_TIME=$(date +%Y%m%d-%H%M%S)
echo "End time: $END_TIME"

LOG_DIR="/var/log/${app_name}"
BOOT_LOG_DIR="/var/log"
S3_BUCKET="${app_name}-instance-logs"
S3_PREFIX="${environment}/$INSTANCE_ID/$START_TIME"_to_"$END_TIME"

echo "Logs will be uploaded to s3://$S3_BUCKET/$S3_PREFIX/"

# Check AWS CLI is available
if ! command -v aws &> /dev/null; then
  echo "Error: AWS CLI not installed, cannot proceed"
else
  # Check IAM credentials with timeout
  echo "Checking AWS identity..."
  aws --cli-connect-timeout 5 --cli-read-timeout 5 sts get-caller-identity --region $REGION && echo "AWS credentials verified" || echo "Warning: Failed to get identity, will try anyway"

  # Create archive of log files
  echo "Creating log archive..."
  cd /var/log
  if [ -d ${app_name} ]; then
    tar -czf "/tmp/${environment}-${app_name}-logs-$START_TIME"_to_"$END_TIME.tar.gz" ${app_name} && \
    echo "Archive created: /tmp/${environment}-${app_name}-logs-$START_TIME"_to_"$END_TIME.tar.gz"
  else
    echo "Warning: /var/log/${app_name} directory not found"
  fi

  # Upload logs to S3 with timeout
  echo "Uploading archive to S3..."
  if [ -f "/tmp/${environment}-${app_name}-logs-$START_TIME"_to_"$END_TIME.tar.gz" ]; then
    # Use shorter timeouts to prevent blocking shutdown
    AWS_CONNECT_TIMEOUT=5
    AWS_READ_TIMEOUT=10
    aws --cli-connect-timeout $AWS_CONNECT_TIMEOUT --cli-read-timeout $AWS_READ_TIMEOUT \
      s3 cp "/tmp/${environment}-${app_name}-logs-$START_TIME"_to_"$END_TIME.tar.gz" \
      "s3://$S3_BUCKET/$S3_PREFIX/${app_name}-logs.tar.gz" --region $REGION && \
    echo "Archive upload successful" || echo "Error: Failed to upload archive"
  else
    echo "Warning: Archive file not found"
  fi
fi

# Also upload individual log files for convenience
if command -v aws &> /dev/null; then
  echo "Uploading individual log files..."
  if [ -d "$LOG_DIR" ]; then
    # Only upload the most important log files to save time during shutdown
    for log_file in $LOG_DIR/${app_name}-application.log $LOG_DIR/${app_name}-error.log $BOOT_LOG_DIR/cloud-init-output.log; do
      if [ -f "$log_file" ]; then
        filename=$(basename "$log_file")
        echo "Uploading $filename..."
        # Use shorter timeouts for each file
        AWS_CONNECT_TIMEOUT=3
        AWS_READ_TIMEOUT=5
        aws --cli-connect-timeout $AWS_CONNECT_TIMEOUT --cli-read-timeout $AWS_READ_TIMEOUT \
          s3 cp "$log_file" "s3://$S3_BUCKET/$S3_PREFIX/$filename" --region $REGION && \
          echo "Successfully uploaded $filename" || echo "Failed to upload $filename, continuing..."
      fi
    done
  else
    echo "Warning: Log directory $LOG_DIR not found"
  fi

  # Upload this log file too
  echo "Uploading script log..."
  aws --cli-connect-timeout 3 --cli-read-timeout 5 \
    s3 cp "$LOGFILE" "s3://$S3_BUCKET/$S3_PREFIX/upload-script.log" --region $REGION || \
    echo "Failed to upload script log, continuing..."
fi

# Clean up temp files
echo "Cleaning up..."
rm -f "/tmp/${environment}-${app_name}-logs-$START_TIME"_to_"$END_TIME.tar.gz"

echo "=== Log upload script completed at $(date) ==="
END_OF_SCRIPT

# Replace the placeholder with actual environment
sed -i "s/environment_PLACEHOLDER/${environment}/g" /opt/app/upload-logs-on-shutdown.sh

# Make script executable and set permissions
sudo chmod +x /opt/app/upload-logs-on-shutdown.sh
sudo chown ${app_name}:${app_name} /opt/app/upload-logs-on-shutdown.sh

# Create systemd service for shutdown log upload
cat > /tmp/upload-logs-shutdown.service << 'EOF'
[Unit]
Before=${app_name}.service
After=network.target
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStop=/opt/app/upload-logs-on-shutdown.sh
User=${app_name}
Group=${app_name}
StandardOutput=append:/var/log/${app_name}/upload-logs-s3-info.log
StandardError=append:/var/log/${app_name}/upload-logs-s3-error.log
[Install]
WantedBy=multi-user.target
EOF


# Create systemd service file with environment-specific profile
cat > /tmp/${app_name}.service << EOF
[Unit]
Description=${app_name} Java Application
After=network.target
[Service]
Type=simple
User=${app_name}
Group=${app_name}
WorkingDirectory=/opt/app
EnvironmentFile=/etc/${app_name}.env
ExecStart=/usr/bin/java -Xms256m -Xmx512m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/${app_name} -Dspring.profiles.active=$ACTIVE_PROFILE -jar /opt/app/${app_name}.jar
Restart=always
RestartSec=10
# Graceful shutdown configuration
TimeoutStopSec=120
KillMode=mixed
KillSignal=SIGTERM
StandardOutput=append:/var/log/${app_name}/${app_name}.log
StandardError=append:/var/log/${app_name}/${app_name}-error.log
# Security Hardening
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
PrivateTmp=true
ReadWritePaths=/opt/app
ReadWritePaths=/var/log/${app_name}
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

# Move service files to systemd directory and enable them
sudo mv /tmp/${app_name}.service /etc/systemd/system/
sudo mv /tmp/upload-logs-shutdown.service /etc/systemd/system/

chmod 755 /opt/app/upload-logs-on-shutdown.sh

sudo systemctl daemon-reload

# Enable and start all services
sudo systemctl enable ${app_name}.service
sudo systemctl enable upload-logs-shutdown.service

# Start the main services
sudo systemctl start ${app_name}.service
sudo systemctl start upload-logs-shutdown.service
# # Also directly modify the system shutdown sequence
# sudo sed -i '2i /opt/app/upload-logs-on-shutdown.sh || true' /etc/rc0.d/K01reboot
# sudo sed -i '2i /opt/app/upload-logs-on-shutdown.sh || true' /etc/rc6.d/K01reboot

sudo systemctl status ${app_name}.service
sudo systemctl status upload-logs-shutdown.service
echo "==== Completed download-latest-artifact.sh $(date) ===="