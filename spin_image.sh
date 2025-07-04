#!/bin/bash

set -e

source ./check_requirements.sh

echo "========================================="
echo "Starting DBChefs Application..."
echo "========================================="

# Hardcoded Database credentials
POSTGRES_DB="db_chefs"
POSTGRES_USER="postgres"
POSTGRES_PASSWORD="123456789"

# Docker Hub repo and image
DOCKER_USERNAME="deepakkundra"
REPOSITORY_NAME="duskbyte"
VERSION="latest"
IMAGE_NAME="$DOCKER_USERNAME/$REPOSITORY_NAME:$VERSION"

# Check if logged in
if ! docker info | grep -q "Username: $DOCKER_USERNAME"; then
  echo "⚠️ You are not logged in to Docker Hub as $DOCKER_USERNAME"
  echo "Attempting to log in..."
  docker login
fi

echo "Pulling image: $IMAGE_NAME"
docker pull $IMAGE_NAME

# Stop and remove any existing container
if [ "$(docker ps -aq -f name=dbchefs-app)" ]; then
    echo "Stopping and removing existing container..."
    docker stop dbchefs-app
    docker rm dbchefs-app
fi

# Run container
echo "Starting container 'dbchefs-app'..."
docker run -d \
  --name dbchefs-app \
  -p 8083:80 \
  -p 5432:5432 \
  -e POSTGRES_DB=$POSTGRES_DB \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e APP_KEY=$APP_KEY \
  $IMAGE_NAME

echo "========================================="
echo "DBChefs Application is running."
echo "========================================="
