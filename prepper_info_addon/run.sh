#!/bin/bash

CONFIG_FILE="/data/options.json"
DOWNLOAD_DIR="/data/resources"

mkdir -p "$DOWNLOAD_DIR"
mkdir -p /data/resources/github

echo "[Prepper Add-on] Starting..."

CRON_SCHEDULE=$(jq -r '.cron_schedule' "$CONFIG_FILE")
echo "$CRON_SCHEDULE /app/update.sh" > /etc/crontab

supercronic /etc/crontab &
python3 /app/prepper_server.py
