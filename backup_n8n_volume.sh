#!/bin/bash

# === CONFIG ===
VOLUME_NAME="ubuntu_n8n_data"
BUCKET_NAME="n8n-volume-backup"
BACKUP_DIR="$HOME/n8n_backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="n8n_data_backup_$TIMESTAMP.tar.gz"
LOG_FILE="$BACKUP_DIR/n8n_backup.log"

# === PREPARE DIRECTORIES ===
mkdir -p "$BACKUP_DIR"

# === CREATE BACKUP ===
echo "[$(date)] Starting backup..." >> "$LOG_FILE"

docker run --rm \
  -v $VOLUME_NAME:/volume \
  -v $BACKUP_DIR:/backup \
  alpine \
  tar czf /backup/$BACKUP_FILE -C /volume . >> "$LOG_FILE" 2>&1

if [ $? -ne 0 ]; then
  echo "[$(date)] ❌ Error during Docker volume backup." >> "$LOG_FILE"
  exit 1
fi

# === UPLOAD TO S3 ===
aws s3 cp "$BACKUP_DIR/$BACKUP_FILE" s3://$BUCKET_NAME/$BACKUP_FILE >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
  echo "[$(date)] ✅ Successfully uploaded $BACKUP_FILE to S3." >> "$LOG_FILE"
  rm -f "$BACKUP_DIR/$BACKUP_FILE"
else
  echo "[$(date)] ❌ Failed to upload $BACKUP_FILE to S3." >> "$LOG_FILE"
fi