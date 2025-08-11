#!/bin/bash

# Take user input for Machine IP Address
while true; do
  echo "Enter IP address of the machine you want to run the controller app (e.g., 192.168.1.100):"
  read machine_ip

  # Basic IPv4 format validation
  if [[ "$machine_ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    # Check each octet is between 0 and 255
    valid=true
    IFS='.' read -ra octets <<< "$machine_ip"
    for octet in "${octets[@]}"; do
      if ((octet < 0 || octet > 255)); then
        valid=false
        break
      fi
    done
    if $valid; then
      break
    else
      echo "Invalid IP address: Each octet must be between 0 and 255."
    fi
  else
    echo "Invalid IP format. Please use IPv4 format (e.g., 192.168.1.100)."
  fi
done


# Take user input for email
while true; do
  echo "Enter email (e.g., test@gmail.com):"
  read email

  # Basic email format validation
  if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    break
  else
    echo "Invalid email format. Please try again."
  fi
done

# Take user input for Machine Count
while true; do
  echo "Enter machine count (e.g., 2):"
  read machine_count

  if [[ "$machine_count" =~ ^[0-9]+$ ]] && [ "$machine_count" -gt 0 ]; then
    break
  else
    echo "Invalid machine count. Please enter a positive number."
  fi
done

# Take user input for Valid From Date with example
while true; do
  echo "Enter valid from date (e.g., 02/08/2025 in DD/MM/YYYY):"
  read valid_from

  if [[ "$valid_from" =~ ^([0-9]{2})/([0-9]{2})/([0-9]{4})$ ]]; then
    break
  else
    echo "Invalid date format. Please use DD/MM/YYYY."
  fi
done

# Take user input for Expiry Date
while true; do
  echo "Enter expires at date (e.g., 02/10/2025 in DD/MM/YYYY):"
  read expires_at

  if [[ "$expires_at" =~ ^([0-9]{2})/([0-9]{2})/([0-9]{4})$ ]]; then
    break
  else
    echo "Invalid date format. Please use DD/MM/YYYY."
  fi
done

# license summary..
echo "===================="
echo "License Details:"
echo "Machine IP: $machine_ip"
echo "Email: $email"
echo "Machine Count: $machine_count"
echo "Valid From: $valid_from"
echo "Expires At: $expires_at"
echo "===================="

# Prepare the string
license_str="${email}|${machine_count}|${valid_from}|${expires_at}|${machine_ip}"

# Encode using PHP
encoded=$(php -r "echo base64_encode('$license_str');")

# Output the result
echo "Encoded License String:"
echo "$encoded"
