check_docker() {
  echo "==========================================="
  echo "Checking system requirements for dbchefs..."
  echo "==========================================="
  echo

  echo "Checking if Docker is installed..."


  if command -v docker &> /dev/null; then
    echo "✔ Docker is installed."
  else
    echo "✗ Docker is not installed."
    echo "Please install Docker before proceeding."
    exit 1
  fi

  echo
}

check_ports() {
  echo "Checking for required ports: 80 (HTTP), 443 (HTTPS), and 5432 (PostgreSQL) ..."

  local missing_ports=()
  local docker_ports=(80 443)
  local docker_port_errors=()

  for port in 80 443 5432; do
    if sudo ss -tulnp | grep -E "LISTEN.+:$port\b" > /dev/null; then
      echo "✔ Port $port is open."

      # If port is 80 or 443, check if Docker is using it
      if [[ " ${docker_ports[*]} " =~ " $port " ]]; then
        if ! sudo ss -tulnp | grep -E "LISTEN.+:$port\b" | grep -q "docker"; then
          echo "✗ Port $port is used by other process."
          docker_port_errors+=("$port")
        fi
      fi

    else
      echo "✗ Port $port is not open."
      missing_ports+=("$port")
    fi
  done

  # If any ports are not open
  if [ ${#missing_ports[@]} -gt 0 ]; then
    echo
    echo "✗ Required ports not open: ${missing_ports[*]}"
    echo "Please make sure ports 80, 443, and 5432 are open before continuing."
    exit 1
  fi

  if [ ${#docker_port_errors[@]} -gt 0 ]; then
    echo "✗ Ports in use by other processes: ${docker_port_errors[*]}"
    exit 1
  fi

  echo "✔ All required ports are open 80 443 5432."
}

check_docker

check_ports