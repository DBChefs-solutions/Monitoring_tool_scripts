#!/bin/bash

set -euo pipefail

DOCKER_USERNAME="dbchefsfsolutions"
REPOSITORY_NAME="monitoring-tool"

VERSION="latest"      
IMAGE_NAME="$DOCKER_USERNAME/$REPOSITORY_NAME:$VERSION"
CONTAINER_NAME="dbchefs-app"

# Host HTTP port (compose maps 80:80)
HTTP_PORT="${HTTP_PORT:-80}"

echo "========================================="
echo "Starting Application..."
echo "Image: $IMAGE_NAME"
echo "========================================="

docker pull "$IMAGE_NAME"

# Stop & remove existing container if present
if docker ps -aq -f name="^${CONTAINER_NAME}$" | grep -q .; then
  echo "Stopping and removing existing container..."
  docker rm -f "$CONTAINER_NAME"
fi

echo "Starting container '$CONTAINER_NAME'..."  

docker run -d \
  --name "$CONTAINER_NAME" \
  --restart unless-stopped \
  -p "${HTTP_PORT}:80" \
  -v dbchefs_postgres_db:/var/lib/postgresql/data \
  -v dbchefs_influxdb_data:/var/lib/influxdb2 \
  "$IMAGE_NAME"

echo "========================================="
echo "DBChefs Application is running."
echo "Container: $CONTAINER_NAME"
echo "Ports:     ${HTTP_PORT}->80"
echo "Volumes:   dbchefs_postgres_db, dbchefs_influxdb_data"
echo "Network:   (default bridge)"
echo "========================================="