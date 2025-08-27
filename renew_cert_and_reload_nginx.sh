#!/bin/bash

# Define volumes relative to the current directory of your project
CERTBOT_WWW="$(pwd)/certbot/www"
CERTBOT_CONF="$(pwd)/certbot/conf"

# Run Certbot renewal using Docker
docker run --rm \
  -v "$CERTBOT_WWW:/var/www/certbot" \
  -v "$CERTBOT_CONF:/etc/letsencrypt" \
  certbot/certbot certonly --webroot -w /var/www/certbot \
  --agree-tos --no-eff-email \
  --email useryser438@gmail.com \
  -d n8n-6ixrams.zapto.org \
  --noninteractive

# Reload NGINX container to apply new certs
docker exec nginx nginx -s reload