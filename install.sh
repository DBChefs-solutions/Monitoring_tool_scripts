#!/bin/bash

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
sudo dpkg -i goAgent_1.0.0_amd64.deb

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
  user: "root"
  password: "duskbyte"
  host: "127.0.0.1"
  port: 3306
  database: ""
EOF

echo "Enabling and starting service"
sudo systemctl daemon-reload
sudo systemctl enable goAgent
sudo systemctl start goAgent

rm -f goAgent.deb

echo "Go Agent installed and running!"
