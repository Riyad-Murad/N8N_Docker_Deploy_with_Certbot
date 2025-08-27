#!/bin/sh

CERT_PATH="/etc/letsencrypt/live/n8n-6ixrams.zapto.org-0001/fullchain.pem"

# If cert exists, use full HTTPS config. If not, use only HTTP.
if [ -f "$CERT_PATH" ]; then
  cp /etc/nginx/templates/full.conf /etc/nginx/conf.d/default.conf
else
  cp /etc/nginx/templates/http.conf /etc/nginx/conf.d/default.conf
fi

# Start nginx in foreground
nginx -g "daemon off;"