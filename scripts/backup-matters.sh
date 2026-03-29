#!/bin/bash
set -e
BACKUP_DIR="${BACKUP_DIR:-$HOME/karlos-backups}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p "$BACKUP_DIR"
[ ! -d "matters/" ] && echo "ERROR: matters/ not found." && exit 1
tar -czf /tmp/matters-$TIMESTAMP.tar.gz matters/
if [ -n "$BACKUP_PASSWORD" ]; then
    openssl enc -aes-256-cbc -salt -pbkdf2 -in /tmp/matters-$TIMESTAMP.tar.gz -out "$BACKUP_DIR/matters-$TIMESTAMP.tar.gz.enc" -pass pass:"$BACKUP_PASSWORD"
    rm /tmp/matters-$TIMESTAMP.tar.gz
    echo "✓ Encrypted backup: $BACKUP_DIR/matters-$TIMESTAMP.tar.gz.enc"
else
    mv /tmp/matters-$TIMESTAMP.tar.gz "$BACKUP_DIR/"
    echo "⚠ Unencrypted backup. Set BACKUP_PASSWORD for encryption."
fi
find "$BACKUP_DIR" -name "matters-*" -mtime +90 -delete
echo "✓ Old backups cleaned."
