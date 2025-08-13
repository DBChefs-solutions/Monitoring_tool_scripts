#!/bin/bash

echo "Stopping goAgent service..."
sudo systemctl stop goAgent

echo "Removing goAgent package..."
sudo dpkg -r goAgent

echo "Deleting goAgent binary..."
sudo rm -f /usr/local/bin/goAgent

echo "Removing systemd service definition..."
sudo rm -f /lib/systemd/system/goAgent.service

echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Removing log files..."
sudo rm -f /var/log/go-agent/error.log
sudo rm -f /var/log/go-agent/access.log
sudo rm -f /var/log/goAgent/error.log
sudo rm -f /var/log/goAgent/access.log

echo "Removing configuration file..."
sudo rm -f /etc/goAgent/config.yml
sudo rm -f /etc/go-agent/config.yml

echo "✔ goAgent cleanup completed."


TOKEN=$1
SERVER_URL=$2
PACKAGE_NAME="goAgent_1.0.0_amd64.deb"  # change this when version changes

if [ -z "$TOKEN" ] || [ -z "$SERVER_URL" ]; then
  echo "Error: Token or Server URL missing."
  echo "Usage: bash -s <AGENT_KEY> <SERVER_URL>"
  exit 1
fi

echo "Downloading $PACKAGE_NAME package..."
curl -fsSL "$SERVER_URL/api/agent/download/$PACKAGE_NAME" -o "$PACKAGE_NAME"

echo "Installing go agent package"
sudo dpkg -i $PACKAGE_NAME

echo "Creating config directory"
sudo mkdir -p /etc/go-agent

# Write YAML config
echo "Saving token, server URL, and default MySQL config to /etc/go-agent/config.yml"
cat <<EOF | sudo tee /etc/go-agent/config.yml > /dev/null
token: "$TOKEN"
server_url: "$SERVER_URL"
log:
  directory: "/var/log/go-agent"
  access_file: "access.log"
  error_file: "error.log"

paths:
  config_path: "/etc/go-agent/config.yml"

mysql:
  user: ""
  password: ""
  host: ""
  port: 
  database: ""
EOF

echo "Enabling and starting service"
sudo systemctl daemon-reload
sudo systemctl enable goAgent
sudo systemctl start goAgent

rm -f goAgent.deb

echo "Go Agent installed and running!"
