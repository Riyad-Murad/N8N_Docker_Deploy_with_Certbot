#!/bin/bash

# Script to update n8n weekly if a new version is available

# Get current image ID
CURRENT_IMAGE_ID=$(docker images --format "{{.Repository}}:{{.Tag}} {{.ID}}" | grep "n8nio/n8n:latest" | awk '{print $2}')

echo "Current n8n image ID: $CURRENT_IMAGE_ID"

# Pull the latest image
# echo "Pulling latest n8n image..."
docker pull n8nio/n8n

# Get new image ID
NEW_IMAGE_ID=$(docker images --format "{{.Repository}}:{{.Tag}} {{.ID}}" | grep "n8nio/n8n:latest" | awk '{print $2}')

echo "New n8n image ID: $NEW_IMAGE_ID"

# Compare IDs
if [ "$CURRENT_IMAGE_ID" != "$NEW_IMAGE_ID" ]; then
    echo "✅ New version detected. Updating n8n..."

    # Restart only the n8n container with the new image
    docker compose up -d --no-deps --build n8n

    # Remove old image
    docker rmi "$CURRENT_IMAGE_ID"

    echo "🎉 n8n updated successfully without restarting nginx/certbot."
else
    echo "ℹ No new version found. Skipping update."
fi