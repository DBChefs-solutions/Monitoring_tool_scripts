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
